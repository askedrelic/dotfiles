#!/usr/bin/env python
########################################################################
# This is transmission-remote-cli, whereas 'cli' stands for 'Curses    #
# Luminous Interface', a client for the daemon of the BitTorrent       #
# client Transmission.                                                 #
#                                                                      #
# This program is free software: you can redistribute it and/or modify #
# it under the terms of the GNU General Public License as published by #
# the Free Software Foundation, either version 3 of the License, or    #
# (at your option) any later version.                                  #
#                                                                      #
# This program is distributed in the hope that it will be useful,      #
# but WITHOUT ANY WARRANTY; without even the implied warranty of       #
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the        #
# GNU General Public License for more details:                         #
# http://www.gnu.org/licenses/gpl-3.0.txt                              #
########################################################################

VERSION = '1.6.0'

TRNSM_VERSION_MIN = '1.90'
TRNSM_VERSION_MAX = '2.80'
RPC_VERSION_MIN = 8
RPC_VERSION_MAX = 15

# error codes
CONNECTION_ERROR = 1
JSON_ERROR       = 2
CONFIGFILE_ERROR = 3


# use simplejson if available because it seems to be faster
try:
    import simplejson as json
except ImportError:
    try:
        # Python 2.6 comes with a json module ...
        import json
        # ...but there is also an old json module that doesn't support .loads/.dumps.
        json.dumps ; json.dumps
    except (ImportError,AttributeError):
        quit("Please install simplejson or Python 2.6 or higher.")

import time
import datetime
import re
import base64
import httplib
import urllib2
import socket
socket.setdefaulttimeout(None)
import ConfigParser
from optparse import OptionParser, SUPPRESS_HELP
import sys
import os
import signal
import unicodedata
import locale
import curses
import curses.ascii
from textwrap import wrap
from subprocess import call, Popen
import netrc
import glob
import operator
import urlparse


# optional features provided by non-standard modules
features = {'dns':False, 'geoip':False, 'ipy':False}
try:   import adns; features['dns'] = True     # resolve IP to host name
except ImportError: features['dns'] = False

try:   import GeoIP; features['geoip'] = True  # show country peer seems to be in
except ImportError:  features['geoip'] = False

try:   import IPy;  features['ipy'] = True  # extract ipv4 from ipv6 addresses
except ImportError: features['ipy'] = False


if features['ipy']:
    IPV6_RANGE_6TO4 = IPy.IP('2002::/16')
    IPV6_RANGE_TEREDO = IPy.IP('2001::/32')
    IPV4_ONES = 0xffffffff

if features['geoip']:
    def country_code_by_addr_vany(geo_ip, geo_ip6, addr):
        if '.' in addr:
            return geo_ip.country_code_by_addr(addr)
        if not ':' in addr:
            return None
        if features['ipy']:
            ip = IPy.IP(addr)
            if ip in IPV6_RANGE_6TO4:
              addr = str(IPy.IP(ip.int() >> 80 & IPV4_ONES))
              return geo_ip.country_code_by_addr(addr)
            elif ip in IPV6_RANGE_TEREDO:
              addr = str(IPy.IP(ip.int() & IPV4_ONES ^ IPV4_ONES))
              return geo_ip.country_code_by_addr(addr)
        if hasattr(geo_ip6, 'country_code_by_addr_v6'):
            return geo_ip6.country_code_by_addr_v6(addr)


# define config defaults
config = ConfigParser.SafeConfigParser()
config.add_section('Connection')
config.set('Connection', 'password', '')
config.set('Connection', 'username', '')
config.set('Connection', 'port', '9091')
config.set('Connection', 'host', 'localhost')
config.set('Connection', 'path', '/transmission/rpc')
config.set('Connection', 'ssl', 'False')
config.add_section('Sorting')
config.set('Sorting', 'order', 'name')
config.add_section('Filtering')
config.set('Filtering', 'filter', '')
config.set('Filtering', 'invert', 'False')
config.add_section('Misc')
config.set('Misc', 'compact_list', 'False')
config.set('Misc', 'blank_lines', 'True')
config.set('Misc', 'torrentname_is_progressbar', 'True')
config.set('Misc', 'file_viewer', 'xdg-open %%s')
config.set('Misc', 'file_open_in_terminal', 'True')
config.add_section('Colors')
config.set('Colors', 'title_seed',       'bg:green,fg:black')
config.set('Colors', 'title_download',   'bg:blue,fg:black')
config.set('Colors', 'title_idle',       'bg:cyan,fg:black')
config.set('Colors', 'title_verify',     'bg:magenta,fg:black')
config.set('Colors', 'title_paused',     'bg:black,fg:white')
config.set('Colors', 'title_error',      'bg:red,fg:white')
config.set('Colors', 'download_rate',    'bg:black,fg:blue')
config.set('Colors', 'upload_rate',      'bg:black,fg:red')
config.set('Colors', 'eta+ratio',        'bg:black,fg:white')
config.set('Colors', 'filter_status',    'bg:red,fg:black')
config.set('Colors', 'dialog',           'bg:black,fg:white')
config.set('Colors', 'dialog_important', 'bg:red,fg:black')
config.set('Colors', 'button',           'bg:white,fg:black')
config.set('Colors', 'button_focused',   'bg:black,fg:white')
config.set('Colors', 'file_prio_high',   'bg:red,fg:black')
config.set('Colors', 'file_prio_normal', 'bg:white,fg:black')
config.set('Colors', 'file_prio_low',    'bg:yellow,fg:black')
config.set('Colors', 'file_prio_off',    'bg:blue,fg:black')


class ColorManager:
    def __init__(self, config):
        self.config = dict()
        self.term_has_colors = curses.has_colors()
        curses.start_color()
        if self.term_has_colors:
            curses.use_default_colors()
        for name in config.keys():
            self.config[name] = self._parse_color_pair(config[name])
            if self.term_has_colors:
                curses.init_pair(self.config[name]['id'],
                                 self.config[name]['fg'],
                                 self.config[name]['bg'])

    def _parse_color_pair(self, pair):
        # BG and FG are intentionally switched here because colors are always
        # used with curses.A_REVERSE. (To be honest, I forgot why, probably
        # has something to do with how highlighting focus works.)
        bg_name = pair.split(',')[1].split(':')[1].upper()
        fg_name = pair.split(',')[0].split(':')[1].upper()
        color_pair = { 'id': len(self.config.keys()) + 1 }
        try:
            color_pair['bg'] = eval('curses.COLOR_' + bg_name)
        except AttributeError:
            color_pair['bg'] = -1
        try:
            color_pair['fg'] = eval('curses.COLOR_' + fg_name)
        except AttributeError:
            color_pair['fg'] = -1
        return color_pair

    def id(self, name): return self.config[name]['id']


class Normalizer:
    def __init__(self):
        self.values = {}

    def add(self, id, value, max):
        if not id in self.values.keys():
            self.values[id] = [ float(value) ]
        else:
            if len(self.values[id]) >= max:
                self.values[id].pop(0)
            self.values[id].append(float(value))
        return self.get(id)

    def get(self, id):
        if not id in self.values.keys():
            return 0.0
        return sum(self.values[id]) / len(self.values[id])



authhandler = None
session_id = 0

# Handle communication with Transmission server.
class TransmissionRequest:
    def __init__(self, host, port, path, method=None, tag=None, arguments=None):
        self.url           = create_url(host, port, path)
        self.open_request  = None
        self.last_update   = 0
        if method and tag:
            self.set_request_data(method, tag, arguments)

    def set_request_data(self, method, tag, arguments=None):
        request_data = {'method':method, 'tag':tag}
        if arguments: request_data['arguments'] = arguments
        self.http_request = urllib2.Request(url=self.url, data=json.dumps(request_data))

    def send_request(self):
        """Ask for information from server OR submit command."""

        global session_id
        try:
            if session_id:
                self.http_request.add_header('X-Transmission-Session-Id', session_id)
            self.open_request = urllib2.urlopen(self.http_request)
        except AttributeError:
            # request data (http_request) isn't specified yet -- data will be available on next call
            pass

        # authentication
        except urllib2.HTTPError, e:
            try:
                msg = html2text(str(e.read()))
            except:
                msg = str(e)

            # extract session id and send request again
            m = re.search('X-Transmission-Session-Id:\s*(\w+)', msg)
            try:
                session_id = m.group(1)
                self.send_request()
            except AttributeError:
                quit(str(msg) + "\n", CONNECTION_ERROR)

        except urllib2.URLError, msg:
            try:
                reason = msg.reason[1]
            except IndexError:
                reason = str(msg.reason)
            quit("Cannot connect to %s: %s\n" % (self.http_request.host, reason), CONNECTION_ERROR)

    def get_response(self):
        """Get response to previously sent request."""

        if self.open_request == None:
            return {'result': 'no open request'}
        response = self.open_request.read()
        # work around regression in Python 2.6.5, caused by http://bugs.python.org/issue8797
        if authhandler:
            authhandler.retried = 0
        try:
            data = json.loads(unicode(response))
        except ValueError:
            quit("Cannot parse response: %s\n" % response, JSON_ERROR)
        self.open_request = None
        return data


# End of Class TransmissionRequest


# Higher level of data exchange
class Transmission:
    STATUS_STOPPED       = 0   # Torrent is stopped
    STATUS_CHECK_WAIT    = 1   # Queued to check files
    STATUS_CHECK         = 2   # Checking files
    STATUS_DOWNLOAD_WAIT = 3   # Queued to download
    STATUS_DOWNLOAD      = 4   # Downloading
    STATUS_SEED_WAIT     = 5   # Queued to seed
    STATUS_SEED          = 6   # Seeding

    TAG_TORRENT_LIST    = 7
    TAG_TORRENT_DETAILS = 77
    TAG_SESSION_STATS   = 21
    TAG_SESSION_GET     = 22

    LIST_FIELDS = [ 'id', 'name', 'downloadDir', 'status', 'trackerStats', 'desiredAvailable',
                    'rateDownload', 'rateUpload', 'eta', 'uploadRatio',
                    'sizeWhenDone', 'haveValid', 'haveUnchecked', 'addedDate',
                    'uploadedEver', 'errorString', 'recheckProgress',
                    'peersConnected', 'uploadLimit', 'downloadLimit',
                    'uploadLimited', 'downloadLimited', 'bandwidthPriority',
                    'peersSendingToUs', 'peersGettingFromUs',
                    'seedRatioLimit', 'seedRatioMode', 'isPrivate' ]

    DETAIL_FIELDS = [ 'files', 'priorities', 'wanted', 'peers', 'trackers',
                      'activityDate', 'dateCreated', 'startDate', 'doneDate',
                      'totalSize', 'leftUntilDone', 'comment',
                      'hashString', 'pieceCount', 'pieceSize', 'pieces',
                      'downloadedEver', 'corruptEver', 'peersFrom' ] + LIST_FIELDS

    def __init__(self, host, port, path, username, password):
        self.host = host
        self.port = port
        self.path = path

        if username and password:
            password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
            password_mgr.add_password(None, create_url(host, port, path), username, password)
            global authhandler
            authhandler = urllib2.HTTPBasicAuthHandler(password_mgr)
            opener = urllib2.build_opener(authhandler)
            urllib2.install_opener(opener)

        # check rpc version
        request = TransmissionRequest(host, port, path, 'session-get', self.TAG_SESSION_GET)
        request.send_request()
        response = request.get_response()

        self.rpc_version = response['arguments']['rpc-version']

        # rpc version too old?
        version_error = "Unsupported Transmission version: " + str(response['arguments']['version']) + \
            " -- RPC protocol version: " + str(response['arguments']['rpc-version']) + "\n"

        min_msg = "Please install Transmission version " + TRNSM_VERSION_MIN + " or higher.\n"
        try:
            if response['arguments']['rpc-version'] < RPC_VERSION_MIN:
                quit(version_error + min_msg)
        except KeyError:
            quit(version_error + min_msg)

        # rpc version too new?
        if response['arguments']['rpc-version'] > RPC_VERSION_MAX:
            quit(version_error + "Please install Transmission version " + TRNSM_VERSION_MAX + " or lower.\n")

        # setup compatibility to Transmission <2.40
        if self.rpc_version < 14:
            Transmission.STATUS_CHECK_WAIT    = 1 << 0
            Transmission.STATUS_CHECK         = 1 << 1
            Transmission.STATUS_DOWNLOAD_WAIT = 1 << 2
            Transmission.STATUS_DOWNLOAD      = 1 << 2
            Transmission.STATUS_SEED_WAIT     = 1 << 3
            Transmission.STATUS_SEED          = 1 << 3
            Transmission.STATUS_STOPPED       = 1 << 4

        # Queue was implemented in Transmission v2.4
        if self.rpc_version >= 14:
            self.LIST_FIELDS.append('queuePosition');
            self.DETAIL_FIELDS.append('queuePosition');
 
        # set up request list
        self.requests = {'torrent-list':
                             TransmissionRequest(host, port, path, 'torrent-get', self.TAG_TORRENT_LIST, {'fields': self.LIST_FIELDS}),
                         'session-stats':
                             TransmissionRequest(host, port, path, 'session-stats', self.TAG_SESSION_STATS, 21),
                         'session-get':
                             TransmissionRequest(host, port, path, 'session-get', self.TAG_SESSION_GET),
                         'torrent-details':
                             TransmissionRequest(host, port, path)}

        self.torrent_cache = []
        self.status_cache  = dict()
        self.torrent_details_cache = dict()
        self.peer_progress_cache   = dict()
        self.hosts_cache   = dict()
        self.geo_ips_cache = dict()
        if features['dns']:   self.resolver = adns.init()
        if features['geoip']:
            self.geo_ip = GeoIP.new(GeoIP.GEOIP_MEMORY_CACHE)
            try:
                self.geo_ip6 = GeoIP.open_type(GeoIP.GEOIP_COUNTRY_EDITION_V6, GeoIP.GEOIP_MEMORY_CACHE);
            except AttributeError: self.geo_ip6 = None
            except GeoIP.error: self.geo_ip6 = None

        # make sure there are no undefined values
        self.wait_for_torrentlist_update()
        self.requests['torrent-details'] = TransmissionRequest(self.host, self.port, self.path)


    def update(self, delay, tag_waiting_for=0):
        """Maintain up-to-date data."""

        tag_waiting_for_occurred = False

        for request in self.requests.values():
            if time.time() - request.last_update >= delay:
                request.last_update = time.time()
                response = request.get_response()

                if response['result'] == 'no open request':
                    request.send_request()

                elif response['result'] == 'success':
                    tag = self.parse_response(response)
                    if tag == tag_waiting_for:
                        tag_waiting_for_occurred = True

        if tag_waiting_for:
            return tag_waiting_for_occurred
        else:
            return None



    def parse_response(self, response):
        def get_main_tracker_domain(torrent):
            if torrent['trackerStats']:
                trackers = sorted(torrent['trackerStats'],
                                  key=operator.itemgetter('tier', 'id'))
                return urlparse.urlparse(trackers[0]['announce']).hostname
            else:
                # Trackerless torrents
                return None

        # response is a reply to torrent-get
        if response['tag'] == self.TAG_TORRENT_LIST or response['tag'] == self.TAG_TORRENT_DETAILS:
            for t in response['arguments']['torrents']:
                t['uploadRatio'] = round(float(t['uploadRatio']), 2)
                t['percentDone'] = percent(float(t['sizeWhenDone']),
                                           float(t['haveValid'] + t['haveUnchecked']))
                t['available'] = t['desiredAvailable'] + t['haveValid'] + t['haveUnchecked']
                if t['downloadDir'][-1] != '/':
                    t['downloadDir'] += '/'
                try:
                    t['seeders']  = max(map(lambda x: x['seederCount'],  t['trackerStats']))
                    t['leechers'] = max(map(lambda x: x['leecherCount'], t['trackerStats']))
                except ValueError:
                    t['seeders']  = t['leechers'] = -1
                t['isIsolated'] = not self.can_has_peers(t)
                t['mainTrackerDomain'] = get_main_tracker_domain(t)

            if response['tag'] == self.TAG_TORRENT_LIST:
                self.torrent_cache = response['arguments']['torrents']

            elif response['tag'] == self.TAG_TORRENT_DETAILS:
                # torrent list may be empty sometimes after deleting
                # torrents.  no idea why and why the server sends us
                # TAG_TORRENT_DETAILS, but just passing seems to help.(?)
                try:
                    torrent_details = response['arguments']['torrents'][0]
                    torrent_details['pieces'] = base64.decodestring(torrent_details['pieces'])
                    self.torrent_details_cache = torrent_details
                    self.upgrade_peerlist()
                except IndexError:
                    pass

        elif response['tag'] == self.TAG_SESSION_STATS:
            self.status_cache.update(response['arguments'])

        elif response['tag'] == self.TAG_SESSION_GET:
            self.status_cache.update(response['arguments'])

        return response['tag']

    def upgrade_peerlist(self):
        for index,peer in enumerate(self.torrent_details_cache['peers']):
            ip = peer['address']
            peerid = ip + self.torrent_details_cache['hashString']

            # make sure peer cache exists
            if not self.peer_progress_cache.has_key(peerid):
                self.peer_progress_cache[peerid] = {'last_progress':peer['progress'], 'last_update':time.time(),
                                                    'download_speed':0, 'time_left':0}

            this_peer = self.peer_progress_cache[peerid]
            this_torrent = self.torrent_details_cache

            # estimate how fast a peer is downloading
            if peer['progress'] < 1:
                this_time = time.time()
                time_diff = this_time - this_peer['last_update']
                progress_diff = peer['progress'] - this_peer['last_progress']
                if this_peer['last_progress'] and progress_diff > 0 and time_diff > 5:
                    download_left = this_torrent['totalSize'] - \
                        (this_torrent['totalSize']*peer['progress'])
                    downloaded = this_torrent['totalSize'] * progress_diff

                    this_peer['download_speed'] = \
                        norm.add(peerid+':download_speed', downloaded/time_diff, 10)
                    this_peer['time_left']   = download_left/this_peer['download_speed']
                    this_peer['last_update'] = this_time

                # infrequent progress updates lead to increasingly inaccurate
                # estimates, so we go back to <guessing>
                elif time_diff > 60:
                    this_peer['download_speed'] = 0
                    this_peer['time_left']      = 0
                    this_peer['last_update']    = time.time()
                this_peer['last_progress'] = peer['progress']  # remember progress
            this_torrent['peers'][index].update(this_peer)

            # resolve and locate peer's ip
            if features['dns'] and not self.hosts_cache.has_key(ip):
                try:
                    self.hosts_cache[ip] = self.resolver.submit_reverse(ip, adns.rr.PTR)
                except adns.Error:
                    pass
            if features['geoip'] and not self.geo_ips_cache.has_key(ip):
                self.geo_ips_cache[ip] = country_code_by_addr_vany(self.geo_ip, self.geo_ip6, ip)
                if self.geo_ips_cache[ip] == None:
                    self.geo_ips_cache[ip] = '?'

    def get_rpc_version(self):
        return self.rpc_version

    def get_global_stats(self):
        return self.status_cache

    def get_torrent_list(self, sort_orders):
        def sort_value(value):
            try:
                return value.lower()
            except AttributeError:
                return value
        try:
            for sort_order in sort_orders:
                self.torrent_cache.sort(key=lambda x: sort_value(x[sort_order['name']]),
                                        reverse=sort_order['reverse'])
        except IndexError:
            return []
        return self.torrent_cache

    def get_torrent_by_id(self, id):
        i = 0
        while self.torrent_cache[i]['id'] != id:  i += 1
        if self.torrent_cache[i]['id'] == id:
            return self.torrent_cache[i]
        else:
            return None


    def get_torrent_details(self):
        return self.torrent_details_cache
    def set_torrent_details_id(self, id):
        if id < 0:
            self.requests['torrent-details'] = TransmissionRequest(self.host, self.port, self.path)
        else:
            self.requests['torrent-details'].set_request_data('torrent-get', self.TAG_TORRENT_DETAILS,
                                                              {'ids':id, 'fields': self.DETAIL_FIELDS})

    def get_hosts(self):
        return self.hosts_cache

    def get_geo_ips(self):
        return self.geo_ips_cache


    def set_option(self, option_name, option_value):
        request = TransmissionRequest(self.host, self.port, self.path, 'session-set', 1, {option_name: option_value})
        request.send_request()
        self.wait_for_status_update()


    def set_rate_limit(self, direction, new_limit, torrent_id=-1):
        data = dict()
        if new_limit <= -1:
            new_limit     = None
            limit_enabled = False
        else:
            limit_enabled = True

        if torrent_id < 0:
            type = 'session-set'
            data['speed-limit-'+direction]            = new_limit
            data['speed-limit-'+direction+'-enabled'] = limit_enabled
        else:
            type = 'torrent-set'
            data['ids'] = [torrent_id]
            data[direction+'loadLimit']   = new_limit
            data[direction+'loadLimited'] = limit_enabled

        request = TransmissionRequest(self.host, self.port, self.path, type, 1, data)
        request.send_request()
        self.wait_for_torrentlist_update()


    def set_seed_ratio(self, ratio, torrent_id=-1):
        data = dict()
        if ratio == -1:
            ratio = None
            mode  = 0   # Use global settings
        elif ratio == 0:
            ratio = None
            mode  = 2   # Seed regardless of ratio
        elif ratio >= 0:
            mode  = 1   # Stop seeding at seedRatioLimit
        else:
            return

        data['ids']            = [torrent_id]
        data['seedRatioLimit'] = ratio
        data['seedRatioMode']  = mode
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-set', 1, data)
        request.send_request()
        self.wait_for_torrentlist_update()


    def increase_bandwidth_priority(self, torrent_id):
        torrent = self.get_torrent_by_id(torrent_id)
        if torrent == None or torrent['bandwidthPriority'] >= 1:
            return False
        else:
            new_priority = torrent['bandwidthPriority'] + 1
            request = TransmissionRequest(self.host, self.port, self.path, 'torrent-set', 1,
                                          {'ids': [torrent_id], 'bandwidthPriority':new_priority})
            request.send_request()
            self.wait_for_torrentlist_update()

    def decrease_bandwidth_priority(self, torrent_id):
        torrent = self.get_torrent_by_id(torrent_id)
        if torrent == None or torrent['bandwidthPriority'] <= -1:
            return False
        else:
            new_priority = torrent['bandwidthPriority'] - 1
            request = TransmissionRequest(self.host, self.port, self.path, 'torrent-set', 1,
                                          {'ids': [torrent_id], 'bandwidthPriority':new_priority})
            request.send_request()
            self.wait_for_torrentlist_update()

    def move_queue(self, torrent_id, new_position):
        args = {'ids': [ torrent_id ] }
        if new_position in ('up', 'down', 'top', 'bottom'):
            method_name = 'queue-move-' + new_position
        elif isinstance(new_position, int):
            method_name = 'torrent-set'
            args['queuePosition'] = min(max(new_position, 0), len(self.torrent_cache)-1)
        else:
            raise ValueError("Is not up/down/top/bottom/<number>: %s" % new_position)

        request = TransmissionRequest(self.host, self.port, self.path, method_name, 1, args)
        request.send_request()
        self.wait_for_torrentlist_update()

    def toggle_turtle_mode(self):
        self.set_option('alt-speed-enabled', not self.status_cache['alt-speed-enabled'])


    def add_torrent(self, location):
        args = {}
        try:
            with  open(location, 'rb') as fp:
                args['metainfo'] = unicode(base64.b64encode(fp.read()))
        # If the file doesnt exist or we cant open it, then it is either a url or needs to
        # be open by the server
        except IOError:
            args['filename'] = location

        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-add', 1, args)
        request.send_request()
        response = request.get_response()
        if response['result'] != 'success':
            return response['result']
        else:
            return ''

    def stop_torrent(self, id):
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-stop', 1, {'ids': [id]})
        request.send_request()
        self.wait_for_torrentlist_update()

    def start_torrent(self, id):
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-start', 1, {'ids': [id]})
        request.send_request()
        self.wait_for_torrentlist_update()

    def verify_torrent(self, id):
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-verify', 1, {'ids': [id]})
        request.send_request()
        self.wait_for_torrentlist_update()

    def reannounce_torrent(self, id):
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-reannounce', 1, {'ids': [id]})
        request.send_request()
        self.wait_for_torrentlist_update()

    def move_torrent(self, torrent_id, new_location):
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-set-location', 1,
                                      {'ids': torrent_id, 'location': new_location, 'move': True})
        request.send_request()
        self.wait_for_torrentlist_update()

    def remove_torrent(self, id):
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-remove', 1, {'ids': [id]})
        request.send_request()
        self.wait_for_torrentlist_update()

    def remove_torrent_local_data(self, id):
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-remove', 1, {'ids': [id], 'delete-local-data':True})
        request.send_request()
        self.wait_for_torrentlist_update()

    def add_torrent_tracker(self, id, tracker):
        data = { 'ids' : [id],
                 'trackerAdd' : [tracker] }
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-set', 1, data)
        request.send_request()
        response = request.get_response()
        return response['result'] if response['result'] != 'success' else ''

    def remove_torrent_tracker(self, id, tracker):
        data = { 'ids' : [id],
                 'trackerRemove' : [tracker] }
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-set', 1, data)
        request.send_request()
        response = request.get_response()
        self.wait_for_torrentlist_update()
        return response['result'] if response['result'] != 'success' else ''

    def increase_file_priority(self, file_nums):
        file_nums = list(file_nums)
        ref_num = file_nums[0]
        for num in file_nums:
            if not self.torrent_details_cache['wanted'][num]:
                ref_num = num
                break
            elif self.torrent_details_cache['priorities'][num] < \
                    self.torrent_details_cache['priorities'][ref_num]:
                ref_num = num
        current_priority = self.torrent_details_cache['priorities'][ref_num]
        if not self.torrent_details_cache['wanted'][ref_num]:
            self.set_file_priority(self.torrent_details_cache['id'], file_nums, 'low')
        elif current_priority == -1:
            self.set_file_priority(self.torrent_details_cache['id'], file_nums, 'normal')
        elif current_priority == 0:
            self.set_file_priority(self.torrent_details_cache['id'], file_nums, 'high')

    def decrease_file_priority(self, file_nums):
        file_nums = list(file_nums)
        ref_num = file_nums[0]
        for num in file_nums:
            if self.torrent_details_cache['priorities'][num] > \
                    self.torrent_details_cache['priorities'][ref_num]:
                ref_num = num
        current_priority = self.torrent_details_cache['priorities'][ref_num]
        if current_priority >= 1:
            self.set_file_priority(self.torrent_details_cache['id'], file_nums, 'normal')
        elif current_priority == 0:
            self.set_file_priority(self.torrent_details_cache['id'], file_nums, 'low')
        elif current_priority == -1:
            self.set_file_priority(self.torrent_details_cache['id'], file_nums, 'off')


    def set_file_priority(self, torrent_id, file_nums, priority):
        request_data = {'ids': [torrent_id]}
        if priority == 'off':
            request_data['files-unwanted'] = file_nums
        else:
            request_data['files-wanted'] = file_nums
            request_data['priority-' + priority] = file_nums
        request = TransmissionRequest(self.host, self.port, self.path, 'torrent-set', 1, request_data)
        request.send_request()
        self.wait_for_details_update()

    def get_file_priority(self, torrent_id, file_num):
        priority = self.torrent_details_cache['priorities'][file_num]
        if not self.torrent_details_cache['wanted'][file_num]: return 'off'
        elif priority <= -1: return 'low'
        elif priority == 0:  return 'normal'
        elif priority >= 1:  return 'high'
        return '?'

    def wait_for_torrentlist_update(self):
        self.wait_for_update(7)
    def wait_for_details_update(self):
        self.wait_for_update(77)
    def wait_for_status_update(self):
        self.wait_for_update(22)
    def wait_for_update(self, update_id):
        self.update(0) # send request
        while True:    # wait for response
            if self.update(0, update_id): break
            time.sleep(0.1)

    def get_status(self, torrent):
        if torrent['status'] == Transmission.STATUS_STOPPED:
            status = 'paused'
        elif torrent['status'] == Transmission.STATUS_CHECK:
            status = 'verifying'
        elif torrent['status'] == Transmission.STATUS_CHECK_WAIT:
            status = 'will verify'
        elif torrent['isIsolated']:
            status = 'isolated'
        elif torrent['status'] == Transmission.STATUS_DOWNLOAD:
            status = ('idle','downloading')[torrent['rateDownload'] > 0]
        elif torrent['status'] == Transmission.STATUS_DOWNLOAD_WAIT:
            status = 'will download (%d)' % torrent['queuePosition']
        elif torrent['status'] == Transmission.STATUS_SEED:
            status = 'seeding'
        elif torrent['status'] == Transmission.STATUS_SEED_WAIT:
            status = 'will seed (%d)' % torrent['queuePosition']
        else:
            status = 'unknown state'
        return status

    def can_has_peers(self, torrent):
        """ Will return True if at least one tracker was successfully queried
        recently, or if DHT is enabled for this torrent and globally, False
        otherwise. """

        # Torrent has trackers?
        if torrent['trackerStats']:
            # Did we try to connect a tracker?
            if any([tracker['hasAnnounced'] for tracker in torrent['trackerStats']]):
                for tracker in torrent['trackerStats']:
                    if tracker['lastAnnounceSucceeded']:
                        return True
            # We didn't try yet; assume at least one is online
            else:
                return True
        # Torrent can use DHT?
        # ('dht-enabled' may be missing; assume DHT is available until we can say for sure)
        if not self.status_cache.has_key('dht-enabled') or \
                (self.status_cache['dht-enabled'] and not torrent['isPrivate']):
            return True
        # No ways of finding peers remaining
        return False

    def get_bandwidth_priority(self, torrent):
        if torrent['bandwidthPriority'] == -1:
            return '-'
        elif torrent['bandwidthPriority'] == 0:
            return ' '
        elif torrent['bandwidthPriority'] == 1:
            return '+'
        else:
            return '?'

# End of Class Transmission





# User Interface
class Interface:
    TRACKER_ITEM_HEIGHT = 6

    def __init__(self):
        self.filter_list    = config.get('Filtering', 'filter')
        self.filter_inverse = config.getboolean('Filtering', 'invert')
        self.sort_orders    = parse_sort_str(config.get('Sorting', 'order'))
        self.compact_list   = config.getboolean('Misc', 'compact_list')
        self.blank_lines    = config.getboolean('Misc', 'blank_lines')
        self.torrentname_is_progressbar = config.getboolean('Misc', 'torrentname_is_progressbar')
        self.file_viewer    = config.get('Misc', 'file_viewer')
        self.file_open_in_terminal = config.getboolean('Misc', 'file_open_in_terminal')

        self.torrents         = server.get_torrent_list(self.sort_orders)
        self.stats            = server.get_global_stats()
        self.torrent_details  = []
        self.selected_torrent = -1  # changes to >-1 when focus >-1 & user hits return
        self.all_paused       = False
        self.highlight_dialog = False
        self.search_focus = 0   # like self.focus but for searches in torrent list
        self.focused_id   = -1  # the id (provided by Transmission) of self.torrents[self.focus]
        self.focus        = -1  # -1: nothing focused; 0: top of list; <# of torrents>-1: bottom of list
        self.scrollpos    = 0   # start of torrentlist
        self.torrents_per_page  = 0 # will be set by manage_layout()
        self.rateDownload_width = self.rateUpload_width = 2

        self.details_category_focus = 0  # overview/files/peers/tracker in details
        self.focus_detaillist       = -1 # same as focus but for details
        self.selected_files         = [] # marked files in details
        self.file_index_map         = {} # Maps local torrent's file indices to server file indices
        self.scrollpos_detaillist   = 0  # same as scrollpos but for details
        self.compact_torrentlist    = False # draw only one line for each torrent in compact mode
        self.exit_now               = False

        locale.setlocale(locale.LC_ALL, '')
        self.encoding = locale.getpreferredencoding() or 'UTF-8'

        self.keybindings = {
            ord('?'):               self.call_list_key_bindings,
            curses.KEY_F1:          self.call_list_key_bindings,
            27:                     self.go_back_or_unfocus,
            curses.KEY_BREAK:       self.go_back_or_unfocus,
            12:                     self.go_back_or_unfocus,
            curses.KEY_BACKSPACE:   self.leave_details,
            ord('q'):               self.go_back_or_quit,
            ord('o'):               self.o_key,
            ord('\n'):              self.enter_key,
            curses.KEY_RIGHT:       self.right_key,
            ord('l'):               self.l_key,
            ord('s'):               self.show_sort_order_menu,
            ord('f'):               self.f_key,
            ord('u'):               self.global_upload,
            ord('d'):               self.global_download,
            ord('U'):               self.torrent_upload,
            ord('D'):               self.torrent_download,
            ord('L'):               self.seed_ratio,
            ord('t'):               self.t_key,
            ord('+'):               self.bandwidth_priority,
            ord('-'):               self.bandwidth_priority,
            ord('J'):               self.J_key,
            ord('K'):               self.K_key,
            ord('p'):               self.pause_unpause_torrent,
            ord('P'):               self.pause_unpause_all_torrent,
            ord('v'):               self.verify_torrent,
            ord('y'):               self.verify_torrent,
            ord('r'):               self.r_key,
            curses.KEY_DC:          self.r_key,
            ord('R'):               self.remove_torrent_local_data,
            curses.KEY_SDC:         self.remove_torrent_local_data,
            curses.KEY_UP:          self.movement_keys,
            ord('k'):               self.movement_keys,
            curses.KEY_DOWN:        self.movement_keys,
            ord('j'):               self.movement_keys,
            curses.KEY_PPAGE:       self.movement_keys,
            curses.KEY_NPAGE:       self.movement_keys,
            curses.KEY_HOME:        self.movement_keys,
            curses.KEY_END:         self.movement_keys,
            ord('g'):               self.movement_keys,
            ord('G'):               self.movement_keys,
            curses.ascii.ctrl(ord('f')): self.movement_keys,
            curses.ascii.ctrl(ord('b')): self.movement_keys,
            curses.ascii.ctrl(ord('n')): self.movement_keys,
            curses.ascii.ctrl(ord('p')): self.movement_keys,
            ord("\t"):              self.move_in_details,
            curses.KEY_BTAB:        self.move_in_details,
            ord('e'):               self.move_in_details,
            ord('c'):               self.move_in_details,
            ord('C'):               self.toggle_compact_torrentlist,
            ord('h'):               self.file_pritority_or_switch_details,
            curses.KEY_LEFT:        self.file_pritority_or_switch_details,
            ord(' '):               self.space_key,
            ord('a'):               self.a_key,
            ord('A'):               self.A_key,
            ord('m'):               self.move_torrent,
            ord('n'):               self.reannounce_torrent,
            ord('/'):               self.dialog_search_torrentlist,
            curses.KEY_SEND:        lambda c: self.move_queue('bottom'),
            curses.KEY_SHOME:       lambda c: self.move_queue('top'),
            curses.KEY_SLEFT:       lambda c: self.move_queue('ppage'),
            curses.KEY_SRIGHT:      lambda c: self.move_queue('npage')
        }

        self.sort_options = [
            ('name','_Name'), ('addedDate','_Age'), ('percentDone','_Progress'),
            ('seeders','_Seeds'), ('leechers','Lee_ches'), ('sizeWhenDone', 'Si_ze'),
            ('status','S_tatus'), ('uploadedEver','Up_loaded'),
            ('rateUpload','_Upload Speed'), ('rateDownload','_Download Speed'),
            ('uploadRatio','_Ratio'), ('peersConnected','P_eers'),
            ('downloadDir', 'L_ocation'), ('mainTrackerDomain', 'Trac_ker') ]

        # queue was implemmented in transmission 2.4
        if server.get_rpc_version() >= 14:
            self.sort_options.append(('queuePosition', '_Queue Position'))

        self.sort_options.append(('reverse','Re_verse'))


        try:
            self.init_screen()
            self.run()
        except:
            self.restore_screen()
            (exc_type, exc_value, exc_traceback) = sys.exc_info()
            raise exc_type, exc_value, exc_traceback
        else:
            self.restore_screen()


    def init_screen(self):
        os.environ['ESCDELAY'] = '0' # make escape usable
        self.screen = curses.initscr()
        curses.noecho() ; curses.cbreak() ; self.screen.keypad(1)
        curses.halfdelay(10) # STDIN timeout

        hide_cursor()

        self.colors = ColorManager(dict(config.items('Colors')))

        # http://bugs.python.org/issue2675
        try:
            del os.environ['LINES']
            del os.environ['COLUMNS']
        except:
            pass

        # http://bugs.python.org/issue2675
        try:
            del os.environ['LINES']
            del os.environ['COLUMNS']
        except:
            pass

        signal.signal(signal.SIGWINCH, lambda y,frame: self.get_screen_size())
        self.get_screen_size()

    def restore_screen(self):
        curses.endwin()

    def enc(self, text):
        return text.encode(self.encoding, 'replace')

    def get_screen_size(self):
        time.sleep(0.1) # prevents curses.error on rapid resizing
        while True:
            curses.endwin()
            self.screen.refresh()
            self.height, self.width = self.screen.getmaxyx()
            # Tracker list breaks if width smaller than 73
            if self.width < 73 or self.height < 16:
                self.screen.erase()
                self.screen.addstr(0,0, "Terminal too small", curses.A_REVERSE + curses.A_BOLD)
                time.sleep(1)
            else:
                break
        self.manage_layout()

    def manage_layout(self):
        self.recalculate_torrents_per_page()
        self.pad_height = max((len(self.torrents)+1) * self.tlist_item_height, self.height)
        self.pad = curses.newpad(self.pad_height, self.width)
        self.detaillistitems_per_page = self.height - 8

        if self.selected_torrent > -1:
            self.rateDownload_width = self.get_rateDownload_width([self.torrent_details])
            self.rateUpload_width   = self.get_rateUpload_width([self.torrent_details])
            self.torrent_title_width = self.width - self.rateUpload_width - 2
            # show downloading column only if torrents is downloading
            if self.torrent_details['status'] == Transmission.STATUS_DOWNLOAD:
                self.torrent_title_width -= self.rateDownload_width + 2

        elif self.torrents:
            self.visible_torrents_start = self.scrollpos/self.tlist_item_height
            self.visible_torrents = self.torrents[self.visible_torrents_start : self.scrollpos/self.tlist_item_height + self.torrents_per_page + 1]
            self.rateDownload_width = self.get_rateDownload_width(self.visible_torrents)
            self.rateUpload_width   = self.get_rateUpload_width(self.visible_torrents)
            self.torrent_title_width = self.width - self.rateUpload_width - 2
            # show downloading column only if any downloading torrents are visible
            if filter(lambda x: x['status']==Transmission.STATUS_DOWNLOAD, self.visible_torrents):
                self.torrent_title_width -= self.rateDownload_width + 2
        else:
            self.visible_torrents = []
            self.torrent_title_width = 80

    def get_rateDownload_width(self, torrents):
        new_width = max(map(lambda x: len(scale_bytes(x['rateDownload'])), torrents))
        new_width = max(max(map(lambda x: len(scale_time(x['eta'])), torrents)), new_width)
        new_width = max(len(scale_bytes(self.stats['downloadSpeed'])), new_width)
        new_width = max(self.rateDownload_width, new_width) # don't shrink
        return new_width

    def get_rateUpload_width(self, torrents):
        new_width = max(map(lambda x: len(scale_bytes(x['rateUpload'])), torrents))
        new_width = max(max(map(lambda x: len(num2str(x['uploadRatio'], '%.02f')), torrents)), new_width)
        new_width = max(len(scale_bytes(self.stats['uploadSpeed'])), new_width)
        new_width = max(self.rateUpload_width, new_width) # don't shrink
        return new_width

    def recalculate_torrents_per_page(self):
        self.lines_per_entry   = 3 if self.blank_lines else 2
        self.tlist_item_height = self.lines_per_entry if not self.compact_list else 1
        self.mainview_height = self.height - 2
        self.torrents_per_page = self.mainview_height / self.tlist_item_height

    def run(self):
        self.draw_title_bar()
        self.draw_stats()
        self.draw_torrent_list()

        while True:
            server.update(1)

            # display torrentlist
            if self.selected_torrent == -1:
                self.draw_torrent_list()

            # display some torrent's details
            else:
                self.draw_details()

            self.stats = server.get_global_stats()
            self.draw_title_bar()  # show shortcuts and stuff
            self.draw_stats()      # show global states
            self.screen.move(0,0)  # in case cursor can't be invisible
            self.handle_user_input()
            if self.exit_now:
                sort_str = ','.join(map(lambda x: ('','reverse:')[x['reverse']] + x['name'], self.sort_orders))
                config.set('Sorting', 'order',   sort_str)
                config.set('Filtering', 'filter', self.filter_list)
                config.set('Filtering', 'invert', str(self.filter_inverse))
                config.set('Misc', 'compact_list', str(self.compact_list))
                config.set('Misc', 'blank_lines', str(self.blank_lines))
                config.set('Misc', 'torrentname_is_progressbar', str(self.torrentname_is_progressbar))
                save_config(cmd_args.configfile)
                return

    def go_back_or_unfocus(self, c):
        if self.focus_detaillist > -1:   # unfocus and deselect file
            self.focus_detaillist     = -1
            self.scrollpos_detaillist = 0
            self.selected_files       = []
        elif self.selected_torrent > -1: # return from details
            self.details_category_focus = 0
            self.selected_torrent = -1
            self.selected_files   = []
        else:
            if self.focus > -1:
                self.scrollpos = 0    # unfocus main list
                self.focus     = -1
            elif self.filter_list:
                self.filter_list = '' # reset filter

    def leave_details(self, c):
        if self.selected_torrent > -1:
            server.set_torrent_details_id(-1)
            self.selected_torrent       = -1
            self.details_category_focus = 0
            self.scrollpos_detaillist   = 0
            self.selected_files         = []

    def go_back_or_quit(self, c):
        if self.selected_torrent == -1:
            self.exit_now = True
        else: # return to list view
            server.set_torrent_details_id(-1)
            self.selected_torrent       = -1
            self.details_category_focus = 0
            self.focus_detaillist       = -1
            self.scrollpos_detaillist   = 0
            self.selected_files         = []

    def space_key(self, c):
        # File list
        if self.selected_torrent > -1 and self.details_category_focus == 1:
            self.select_unselect_file(c)
        # Torrent list
        elif self.selected_torrent == -1:
            self.enter_key(c)

    def A_key(self, c):
        # File list
        if self.selected_torrent > -1 and self.details_category_focus == 1:
            self.select_unselect_file(c)

    def a_key(self, c):
        # File list
        if self.selected_torrent > -1 and self.details_category_focus == 1:
            self.select_unselect_file(c)
        # Trackers
        elif self.selected_torrent > -1 and self.details_category_focus == 3:
            self.add_tracker()

        # Do nothing in other detail tabs
        elif self.selected_torrent > -1:
            pass
        else:
            self.add_torrent()

    def o_key(self, c):
        if self.selected_torrent == -1:
            self.draw_options_dialog()
        elif self.selected_torrent > -1:
            self.details_category_focus = 0

    def l_key(self, c):
        if self.focus > -1 and self.selected_torrent == -1:
            self.enter_key(c)
        elif self.selected_torrent > -1:
            self.file_pritority_or_switch_details(c)

    def t_key(self, c):
        if self.selected_torrent == -1:
            server.toggle_turtle_mode()
        elif self.selected_torrent > -1:
            self.details_category_focus = 3

    def f_key(self, c):
        if self.selected_torrent == -1:
            self.show_state_filter_menu(c)
        elif self.selected_torrent > -1:
            self.details_category_focus = 1

    def r_key(self, c):
        # Torrent list
        if self.selected_torrent == -1:
            self.remove_torrent(c)
        # Trackers
        elif self.selected_torrent > -1 and self.details_category_focus == 3:
            self.remove_tracker()

    def J_key(self, c):
        if self.selected_torrent > -1 and self.details_category_focus == 1:
            self.move_to_next_directory_in_filelist()
        else:
            self.move_queue('down')

    def K_key(self, c):
        if self.selected_torrent > -1 and self.details_category_focus == 1:
            self.move_to_previous_directory_in_filelist()
        else:
            self.move_queue('up')

    def right_key(self, c):
        if self.focus > -1 and self.selected_torrent == -1:
            self.enter_key(c)
        else:
            self.file_pritority_or_switch_details(c)

    def add_torrent(self):
        location = self.dialog_input_text("Add torrent from file or URL", homedir2tilde(os.getcwd()+os.sep), tab_complete='all')
        if location:
            error = server.add_torrent(tilde2homedir(location))
            if error:
                msg = wrap("Couldn't add torrent \"%s\":" % location)
                msg.extend(wrap(error, self.width-4))
                self.dialog_ok("\n".join(msg))

    def enter_key(self, c):
        # Torrent list
        if self.focus > -1 and self.selected_torrent == -1:
            self.screen.clear()
            self.selected_torrent = self.focus
            server.set_torrent_details_id(self.torrents[self.focus]['id'])
            server.wait_for_details_update()
        # File list
        elif self.selected_torrent > -1 and self.details_category_focus == 1:
            self.open_torrent_file(c)


    def show_sort_order_menu(self, c):
        if self.selected_torrent == -1:
           choice = self.dialog_menu('Sort order', self.sort_options,
                                     map(lambda x: x[0]==self.sort_orders[-1]['name'], self.sort_options).index(True)+1)
           if choice != -128:
               if choice == 'reverse':
                   self.sort_orders[-1]['reverse'] = not self.sort_orders[-1]['reverse']
               else:
                   self.sort_orders.append({'name':choice, 'reverse':False})
                   while len(self.sort_orders) > 2:
                       self.sort_orders.pop(0)

    def show_state_filter_menu(self, c):
        if self.selected_torrent == -1:
            options = [('uploading','_Uploading'), ('downloading','_Downloading'),
                       ('active','Ac_tive'), ('paused','_Paused'), ('seeding','_Seeding'),
                       ('incomplete','In_complete'), ('verifying','Verif_ying'),
                       ('private','P_rivate'), ('isolated', '_Isolated'),
                       ('invert','In_vert'), ('','_All')]
            choice = self.dialog_menu(('Show only','Filter all')[self.filter_inverse], options,
                                      map(lambda x: x[0]==self.filter_list, options).index(True)+1)
            if choice != -128:
                if choice == 'invert':
                    self.filter_inverse = not self.filter_inverse
                else:
                    if choice == '':
                        self.filter_inverse = False
                    self.filter_list = choice

    def global_upload(self, c):
       current_limit = (-1,self.stats['speed-limit-up'])[self.stats['speed-limit-up-enabled']]
       limit = self.dialog_input_number("Global upload limit in kilobytes per second", current_limit)
       if limit == -128:
           return 
       server.set_rate_limit('up', limit)

    def global_download(self, c):
       current_limit = (-1,self.stats['speed-limit-down'])[self.stats['speed-limit-down-enabled']]
       limit = self.dialog_input_number("Global download limit in kilobytes per second", current_limit)
       if limit == -128:
           return 
       server.set_rate_limit('down', limit)

    def torrent_upload(self, c):
        if self.focus > -1:
            current_limit = (-1,self.torrents[self.focus]['uploadLimit'])[self.torrents[self.focus]['uploadLimited']]
            limit = self.dialog_input_number("Upload limit in kilobytes per second for\n%s" % \
                                                 self.torrents[self.focus]['name'], current_limit)
            if limit == -128:
                return 
            server.set_rate_limit('up', limit, self.torrents[self.focus]['id'])

    def torrent_download(self, c):
        if self.focus > -1:
            current_limit = (-1,self.torrents[self.focus]['downloadLimit'])[self.torrents[self.focus]['downloadLimited']]
            limit = self.dialog_input_number("Download limit in Kilobytes per second for\n%s" % \
                                                 self.torrents[self.focus]['name'], current_limit)
            if limit == -128:
                return 
            server.set_rate_limit('down', limit, self.torrents[self.focus]['id'])

    def seed_ratio(self, c):
        if self.focus > -1:
            if self.torrents[self.focus]['seedRatioMode'] == 0:   # Use global settings
                current_limit = ''
            elif self.torrents[self.focus]['seedRatioMode'] == 1: # Stop seeding at seedRatioLimit
                current_limit = self.torrents[self.focus]['seedRatioLimit']
            elif self.torrents[self.focus]['seedRatioMode'] == 2: # Seed regardless of ratio
                current_limit = -1
            limit = self.dialog_input_number("Seed ratio limit for\n%s" % self.torrents[self.focus]['name'],
                                             current_limit, floating_point=True, allow_empty=True)
            if limit == -1:
                limit = 0
            if limit == -2: # -2 means 'empty' in dialog_input_number return codes
                limit = -1
            server.set_seed_ratio(float(limit), self.torrents[self.focus]['id'])

    def bandwidth_priority(self, c):
        if c == ord('-') and self.focus > -1:
            server.decrease_bandwidth_priority(self.torrents[self.focus]['id'])
        elif c == ord('+') and self.focus > -1:
            server.increase_bandwidth_priority(self.torrents[self.focus]['id'])

    def move_queue(self, direction):
        # queue was implemmented in Transmission v2.4
        if server.get_rpc_version() >= 14 and self.focus > -1:
            if direction in ('ppage', 'npage'):
                new_position = self.torrents[self.focus]['queuePosition']
                if direction == 'ppage':
                    new_position -= 10
                else:
                    new_position += 10
            else:
                new_position = direction
            server.move_queue(self.torrents[self.focus]['id'], new_position)

    def pause_unpause_torrent(self, c):
        if self.focus > -1:
            if self.selected_torrent > -1:
                t = self.torrent_details
            else:
                t = self.torrents[self.focus]
            if t['status'] == Transmission.STATUS_STOPPED:
                server.start_torrent(t['id'])
            else:
                server.stop_torrent(t['id'])

    def pause_unpause_all_torrent(self, c):
        if self.all_paused:
            for t in self.torrents:
                server.start_torrent(t['id'])
            self.all_paused = False
        else:
            for t in self.torrents:
                server.stop_torrent(t['id'])
            self.all_paused = True

    def verify_torrent(self, c):
        if self.focus > -1:
            if self.torrents[self.focus]['status'] != Transmission.STATUS_CHECK \
           and self.torrents[self.focus]['status'] != Transmission.STATUS_CHECK_WAIT:
                server.verify_torrent(self.torrents[self.focus]['id'])

    def reannounce_torrent(self, c):
        if self.focus > -1:
            server.reannounce_torrent(self.torrents[self.focus]['id'])

    def remove_torrent(self, c):
        if self.focus > -1:
            name = self.torrents[self.focus]['name'][0:self.width - 15]
            if self.dialog_yesno("Remove %s?" % name) == True:
                if self.selected_torrent > -1:  # leave details
                    server.set_torrent_details_id(-1)
                    self.selected_torrent = -1
                    self.details_category_focus = 0
                server.remove_torrent(self.torrents[self.focus]['id'])
                self.focus_next_after_delete()

    def remove_torrent_local_data(self, c):
        if self.focus > -1:
            name = self.torrents[self.focus]['name'][0:self.width - 15]
            if self.dialog_yesno("Remove and delete %s?" % name, important=True) == True:
                if self.selected_torrent > -1:  # leave details
                    server.set_torrent_details_id(-1)
                    self.selected_torrent = -1
                    self.details_category_focus = 0
                server.remove_torrent_local_data(self.torrents[self.focus]['id'])
                self.focus_next_after_delete()

    def focus_next_after_delete(self):
        """ Focus next torrent after user deletes torrent """
        new_focus = min(self.focus + 1, len(self.torrents) - 2)
        self.focused_id = self.torrents[new_focus]['id']

    def add_tracker(self):
        if server.get_rpc_version() < 10:
            self.dialog_ok("You need Transmission v2.10 or higher to add trackers.")
            return

        tracker = self.dialog_input_text('Add tracker URL:')
        if tracker:
            t = self.torrent_details
            response = server.add_torrent_tracker(t['id'], tracker)

            if response:
                msg = wrap("Couldn't add tracker: %s" % response)
                self.dialog_ok("\n".join(msg))

    def remove_tracker(self):
        if server.get_rpc_version() < 10:
            self.dialog_ok("You need Transmission v2.10 or higher to remove trackers.")
            return

        t = self.torrent_details
        if (self.scrollpos_detaillist >= 0 and \
            self.scrollpos_detaillist < len(t['trackerStats']) and \
            self.dialog_yesno("Do you want to remove this tracker?") is True):

            tracker = t['trackerStats'][self.scrollpos_detaillist]
            response = server.remove_torrent_tracker(t['id'], tracker['id'])

            if response:
                msg = wrap("Couldn't remove tracker: %s" % response)
                self.dialog_ok("\n".join(msg))

    def movement_keys(self, c):
        if self.selected_torrent == -1 and len(self.torrents) > 0:
            if   c == curses.KEY_UP or c == ord('k') or c == curses.ascii.ctrl(ord('p')):
                self.focus, self.scrollpos = self.move_up(self.focus, self.scrollpos, self.tlist_item_height)
            elif c == curses.KEY_DOWN or c == ord('j') or c == curses.ascii.ctrl(ord('n')):
                self.focus, self.scrollpos = self.move_down(self.focus, self.scrollpos, self.tlist_item_height,
                                                            self.torrents_per_page, len(self.torrents))
            elif c == curses.KEY_PPAGE or c == curses.ascii.ctrl(ord('b')):
                self.focus, self.scrollpos = self.move_page_up(self.focus, self.scrollpos, self.tlist_item_height,
                                                               self.torrents_per_page)
            elif c == curses.KEY_NPAGE or c == curses.ascii.ctrl(ord('f')):
                self.focus, self.scrollpos = self.move_page_down(self.focus, self.scrollpos, self.tlist_item_height,
                                                                 self.torrents_per_page, len(self.torrents))
            elif c == curses.KEY_HOME or c == ord('g'):
                self.focus, self.scrollpos = self.move_to_top()
            elif c == curses.KEY_END or c == ord('G'):
                self.focus, self.scrollpos = self.move_to_end(self.tlist_item_height, self.torrents_per_page, len(self.torrents))
            self.focused_id = self.torrents[self.focus]['id']
        elif self.selected_torrent > -1:
            # file list
            if self.details_category_focus == 1:
                # focus/movement
                if c == curses.KEY_UP or c == ord('k') or c == curses.ascii.ctrl(ord('p')):
                    self.focus_detaillist, self.scrollpos_detaillist = \
                        self.move_up(self.focus_detaillist, self.scrollpos_detaillist, 1)
                elif c == curses.KEY_DOWN or c == ord('j') or c == curses.ascii.ctrl(ord('n')):
                    self.focus_detaillist, self.scrollpos_detaillist = \
                        self.move_down(self.focus_detaillist, self.scrollpos_detaillist, 1,
                                       self.detaillistitems_per_page, len(self.torrent_details['files']))
                elif c == curses.KEY_PPAGE or c == curses.ascii.ctrl(ord('b')):
                    self.focus_detaillist, self.scrollpos_detaillist = \
                        self.move_page_up(self.focus_detaillist, self.scrollpos_detaillist, 1,
                                          self.detaillistitems_per_page)
                elif c == curses.KEY_NPAGE or c == curses.ascii.ctrl(ord('f')):
                    self.focus_detaillist, self.scrollpos_detaillist = \
                        self.move_page_down(self.focus_detaillist, self.scrollpos_detaillist, 1,
                                            self.detaillistitems_per_page, len(self.torrent_details['files']))
                elif c == curses.KEY_HOME or c == ord('g'):
                    self.focus_detaillist, self.scrollpos_detaillist = self.move_to_top()
                elif c == curses.KEY_END or c == ord('G'):
                    self.focus_detaillist, self.scrollpos_detaillist = \
                        self.move_to_end(1, self.detaillistitems_per_page, len(self.torrent_details['files']))
            list_len = 0

            # peer list movement
            if self.details_category_focus == 2:
                list_len = len(self.torrent_details['peers'])

            # tracker list movement
            elif self.details_category_focus == 3:
                list_len = len(self.torrent_details['trackerStats'])

            # pieces list movement
            elif self.details_category_focus == 4:
                piece_count = self.torrent_details['pieceCount']
                margin = len(str(piece_count)) + 2
                map_width = int(str(self.width-margin-1)[0:-1] + '0')
                list_len = int(piece_count / map_width) + 1

            if list_len:
                if c == curses.KEY_UP or c == ord('k') or c == curses.ascii.ctrl(ord('p')):
                    if self.scrollpos_detaillist > 0:
                        self.scrollpos_detaillist -= 1
                elif c == curses.KEY_DOWN or c == ord('j') or c == curses.ascii.ctrl(ord('n')):
                    if self.scrollpos_detaillist < list_len - 1:
                        self.scrollpos_detaillist += 1
                elif c == curses.KEY_PPAGE or c == curses.ascii.ctrl(ord('b')):
                    self.scrollpos_detaillist = \
                        max(self.scrollpos_detaillist - self.detaillistitems_per_page - 1, 0)
                elif c == curses.KEY_NPAGE or c == curses.ascii.ctrl(ord('f')):
                    if self.scrollpos_detaillist + self.detaillistitems_per_page >= list_len:
                        self.scrollpos_detaillist = list_len - 1
                    else:
                        self.scrollpos_detaillist += self.detaillistitems_per_page
                elif c == curses.KEY_HOME or c == ord('g'):
                    self.scrollpos_detaillist = 0
                elif c == curses.KEY_END or c == ord('G'):
                    self.scrollpos_detaillist = list_len - 1

            # Disallow scrolling past the last item that would cause blank
            # space to be displayed in pieces and peer lists.
            if self.details_category_focus in (2, 4):
                self.scrollpos_detaillist = min(self.scrollpos_detaillist,
                    max(0, list_len - self.detaillistitems_per_page))

    def file_pritority_or_switch_details(self, c):
        if self.selected_torrent > -1:
            # file priority OR walk through details
            if c == curses.KEY_RIGHT or c == ord('l'):
                if self.details_category_focus == 1 and \
                        (self.selected_files or self.focus_detaillist > -1):
                    if self.selected_files:
                        files = set([self.file_index_map[index] for index in self.selected_files])
                        server.increase_file_priority(files)
                    elif self.focus_detaillist > -1:
                        server.increase_file_priority([self.file_index_map[self.focus_detaillist]])
                else:
                    self.scrollpos_detaillist = 0
                    self.next_details()
            elif c == curses.KEY_LEFT or c == ord('h'):
                if self.details_category_focus == 1 and \
                        (self.selected_files or self.focus_detaillist > -1):
                    if self.selected_files:
                        files = set([self.file_index_map[index] for index in self.selected_files])
                        server.decrease_file_priority(files)
                    elif self.focus_detaillist > -1:
                        server.decrease_file_priority([self.file_index_map[self.focus_detaillist]])
                else:
                    self.scrollpos_detaillist = 0
                    self.prev_details()

    def select_unselect_file(self, c):
        if self.selected_torrent > -1 and self.details_category_focus == 1 and self.focus_detaillist >= 0:
            # file selection with space
            if c == ord(' '):
                try:
                    self.selected_files.pop(self.selected_files.index(self.focus_detaillist))
                except ValueError:
                    self.selected_files.append(self.focus_detaillist)
                curses.ungetch(curses.KEY_DOWN) # move down
            # (un)select directory
            elif c == ord('A'):
                file_id = self.file_index_map[self.focus_detaillist]
                focused_dir = os.path.dirname(self.torrent_details['files'][file_id]['name'])
                if self.selected_files.count(self.focus_detaillist):
                    for focus in range(0, len(self.torrent_details['files'])):
                        file_id = self.file_index_map[focus]
                        if self.torrent_details['files'][file_id]['name'].startswith(focused_dir):
                            try:
                                while focus in self.selected_files:
                                    self.selected_files.remove(focus)
                            except ValueError:
                                pass
                else:
                    for focus in range(0, len(self.torrent_details['files'])):
                        file_id = self.file_index_map[focus]
                        if self.torrent_details['files'][file_id]['name'].startswith(focused_dir):
                            self.selected_files.append(focus)
                self.move_to_next_directory_in_filelist()
            # (un)select all files
            elif c == ord('a'):
                if self.selected_files:
                    self.selected_files = []
                else:
                    self.selected_files = range(0, len(self.torrent_details['files']))

    def move_to_next_directory_in_filelist(self):
        if self.selected_torrent > -1 and self.details_category_focus == 1:
            self.focus_detaillist = max(self.focus_detaillist, 0)
            file_id = self.file_index_map[self.focus_detaillist]
            focused_dir = os.path.dirname(self.torrent_details['files'][file_id]['name'])
            while self.torrent_details['files'][file_id]['name'].startswith(focused_dir) \
                    and self.focus_detaillist < len(self.torrent_details['files'])-1:
                self.movement_keys(curses.KEY_DOWN)
                file_id = self.file_index_map[self.focus_detaillist]

    def move_to_previous_directory_in_filelist(self):
        if self.selected_torrent > -1 and self.details_category_focus == 1:
            self.focus_detaillist = max(self.focus_detaillist, 0)
            file_id = self.file_index_map[self.focus_detaillist]
            focused_dir = os.path.dirname(self.torrent_details['files'][file_id]['name'])
            while self.torrent_details['files'][file_id]['name'].startswith(focused_dir) \
                    and self.focus_detaillist > 0:
                self.movement_keys(curses.KEY_UP)
                file_id = self.file_index_map[self.focus_detaillist]

    def open_torrent_file(self, c):
        if self.focus_detaillist >= 0:
            details = server.get_torrent_details()
            stats = server.get_global_stats()

            file_server_index = self.file_index_map[self.focus_detaillist]
            file_name = details['files'][file_server_index]['name']

            download_dir = details['downloadDir']
            incomplete_dir = stats['incomplete-dir'] + '/'
        
            file_path = None
            possible_file_locations = [
                    download_dir + file_name,
                    download_dir + file_name + '.part',
                    incomplete_dir + file_name,
                    incomplete_dir + file_name + '.part'
            ]

            for f in possible_file_locations:
                if (os.path.isfile(f)):
                    file_path = f
                    break

            if file_path is None:
                self.get_screen_size()
                self.dialog_ok("Could not find file:\n%s" % (file_name))
                return

            viewer_cmd=[]
            for argstr in self.file_viewer.split(" "):
                viewer_cmd.append(argstr.replace('%s', file_path))
            try:
                if self.file_open_in_terminal:
                    self.restore_screen()
                    call(viewer_cmd)
                    self.get_screen_size()
                else:
                    devnull = open(os.devnull, 'wb')
                    Popen(viewer_cmd, stdout=devnull, stderr=devnull)
                    devnull.close()
            except OSError, err:
                self.get_screen_size()
                self.dialog_ok("%s:\n%s" % (" ".join(viewer_cmd), err))

    def move_in_details(self, c):
        if self.selected_torrent > -1:
            if c == ord("\t"):
                self.next_details()
            elif c == curses.KEY_BTAB:
                self.prev_details()
            elif c == ord('e'):
                self.details_category_focus = 2
            elif c == ord('c'):
                self.details_category_focus = 4

    def call_list_key_bindings(self, c):
        self.list_key_bindings()

    def toggle_compact_torrentlist(self, c):
        self.compact_list = not self.compact_list
        self.recalculate_torrents_per_page()
        self.follow_list_focus()

    def move_torrent(self, c):
        if self.focus > -1:
            location = homedir2tilde(self.torrents[self.focus]['downloadDir'])
            msg = 'Move "%s" from\n%s to' % (self.torrents[self.focus]['name'], location)
            path = self.dialog_input_text(msg, location, tab_complete='dirs')
            if path:
                server.move_torrent(self.torrents[self.focus]['id'], tilde2homedir(path))

    def handle_user_input(self):
        c = self.screen.getch()
        if c == -1:
            return 0

        f = self.keybindings.get(c, None)
        if f:
            f(c)

        # update view
        if self.selected_torrent == -1:
            self.draw_torrent_list()
        else:
            self.draw_details()

    def filter_torrent_list(self):
        unfiltered = self.torrents
        if self.filter_list == 'downloading':
            self.torrents = [t for t in self.torrents if t['rateDownload'] > 0]
        elif self.filter_list == 'uploading':
            self.torrents = [t for t in self.torrents if t['rateUpload'] > 0]
        elif self.filter_list == 'paused':
            self.torrents = [t for t in self.torrents if t['status'] == Transmission.STATUS_STOPPED]
        elif self.filter_list == 'seeding':
            self.torrents = [t for t in self.torrents if t['status'] == Transmission.STATUS_SEED \
                                 or t['status'] == Transmission.STATUS_SEED_WAIT]
        elif self.filter_list == 'incomplete':
            self.torrents = [t for t in self.torrents if t['percentDone'] < 100]
        elif self.filter_list == 'private':
            self.torrents = [t for t in self.torrents if t['isPrivate']]
        elif self.filter_list == 'active':
            self.torrents = [t for t in self.torrents if t['peersGettingFromUs'] > 0 \
                                 or t['peersSendingToUs'] > 0 \
                                 or t['status'] == Transmission.STATUS_CHECK]
        elif self.filter_list == 'verifying':
            self.torrents = [t for t in self.torrents if t['status'] == Transmission.STATUS_CHECK \
                                 or t['status'] == Transmission.STATUS_CHECK_WAIT]
        elif self.filter_list == 'isolated':
            self.torrents = [t for t in self.torrents if t['isIsolated']]
        # invert list?
        if self.filter_inverse:
            self.torrents = [t for t in unfiltered if t not in self.torrents]

    def follow_list_focus(self):
        if self.focus == -1:
            return

        # check if list is empty or id to look for isn't in list
        ids = [t['id'] for t in self.torrents]
        if len(self.torrents) == 0 or self.focused_id not in ids:
            self.focus, self.scrollpos = -1, 0
            return

        # find focused_id
        self.focus = min(self.focus, len(self.torrents)-1)
        if self.torrents[self.focus]['id'] != self.focused_id:
            for i,t in enumerate(self.torrents):
                if t['id'] == self.focused_id:
                    self.focus = i
                    break

        # make sure the focus is not above the visible area
        while self.focus < (self.scrollpos/self.tlist_item_height):
            self.scrollpos -= self.tlist_item_height
        # make sure the focus is not below the visible area
        while self.focus > (self.scrollpos/self.tlist_item_height) + self.torrents_per_page-1:
            self.scrollpos += self.tlist_item_height
        # keep min and max bounds
        self.scrollpos = min(self.scrollpos, (len(self.torrents) - self.torrents_per_page) * self.tlist_item_height)
        self.scrollpos = max(0, self.scrollpos)

    def draw_torrent_list(self, search_keyword=''):
        self.torrents = server.get_torrent_list(self.sort_orders)
        self.filter_torrent_list()

        if search_keyword:
            matched_torrents = [t for t in self.torrents if search_keyword.lower() in t['name'].lower()]
            if matched_torrents:
                self.focus = 0
                if self.search_focus >= len(matched_torrents):
                    self.search_focus = 0
                self.focused_id = matched_torrents[self.search_focus]['id']
                self.highlight_dialog = False
            else:
                self.highlight_dialog = True
                curses.beep()
        else:
            self.search_focus = 0

        self.follow_list_focus()
        self.manage_layout()

        ypos = 0
        for i in range(len(self.visible_torrents)):
            ypos += self.draw_torrentlist_item(self.visible_torrents[i],
                                               (i == self.focus-self.visible_torrents_start),
                                               self.compact_list,
                                               ypos)

        self.pad.refresh(0,0, 1,0, self.mainview_height,self.width-1)
        self.screen.refresh()


    def draw_torrentlist_item(self, torrent, focused, compact, y):
        # the torrent name is also a progress bar
        self.draw_torrentlist_title(torrent, focused, self.torrent_title_width, y)

        rates = ''
        if torrent['status'] == Transmission.STATUS_DOWNLOAD:
            self.draw_downloadrate(torrent, y)
        if torrent['status'] == Transmission.STATUS_DOWNLOAD or torrent['status'] == Transmission.STATUS_SEED:
            self.draw_uploadrate(torrent, y)

        if not compact:
            # the line below the title/progress
            if torrent['percentDone'] < 100 and torrent['status'] == Transmission.STATUS_DOWNLOAD:
                self.draw_eta(torrent, y)

            self.draw_ratio(torrent, y)
            self.draw_torrentlist_status(torrent, focused, y)

            return self.lines_per_entry # number of lines that were used for drawing the list item
        else:
            # Draw ratio in place of upload rate if upload rate = 0
            if not torrent['rateUpload']:
                self.draw_ratio(torrent, y - 1)

            return 1

    def draw_downloadrate(self, torrent, ypos):
        self.pad.move(ypos, self.width-self.rateDownload_width-self.rateUpload_width-3)
        self.pad.addch(curses.ACS_DARROW, (0,curses.A_BOLD)[torrent['downloadLimited']])
        rate = ('',scale_bytes(torrent['rateDownload']))[torrent['rateDownload']>0]
        self.pad.addstr(rate.rjust(self.rateDownload_width),
                        curses.color_pair(self.colors.id('download_rate')) + curses.A_BOLD + curses.A_REVERSE)
    def draw_uploadrate(self, torrent, ypos):
        self.pad.move(ypos, self.width-self.rateUpload_width-1)
        self.pad.addch(curses.ACS_UARROW, (0,curses.A_BOLD)[torrent['uploadLimited']])
        rate = ('',scale_bytes(torrent['rateUpload']))[torrent['rateUpload']>0]
        self.pad.addstr(rate.rjust(self.rateUpload_width),
                        curses.color_pair(self.colors.id('upload_rate')) + curses.A_BOLD + curses.A_REVERSE)
    def draw_ratio(self, torrent, ypos):
        self.pad.addch(ypos+1, self.width-self.rateUpload_width-1, curses.ACS_DIAMOND,
                       (0,curses.A_BOLD)[torrent['uploadRatio'] < 1 and torrent['uploadRatio'] >= 0])
        self.pad.addstr(ypos+1, self.width-self.rateUpload_width,
                        num2str(torrent['uploadRatio'], '%.02f').rjust(self.rateUpload_width),
                        curses.color_pair(self.colors.id('eta+ratio')) + curses.A_BOLD + curses.A_REVERSE)
    def draw_eta(self, torrent, ypos):
        self.pad.addch(ypos+1, self.width-self.rateDownload_width-self.rateUpload_width-3, curses.ACS_PLMINUS)
        self.pad.addstr(ypos+1, self.width-self.rateDownload_width-self.rateUpload_width-2,
                        scale_time(torrent['eta']).rjust(self.rateDownload_width),
                        curses.color_pair(self.colors.id('eta+ratio')) + curses.A_BOLD + curses.A_REVERSE)


    def draw_torrentlist_title(self, torrent, focused, width, ypos):
        if torrent['status'] == Transmission.STATUS_CHECK:
            percentDone = float(torrent['recheckProgress']) * 100
        else:
            percentDone = torrent['percentDone']

        bar_width = int(float(width) * (float(percentDone)/100))

        size = "%6s" % scale_bytes(torrent['sizeWhenDone'])
        if torrent['percentDone'] < 100:
            if torrent['seeders'] <= 0 and torrent['status'] != Transmission.STATUS_CHECK:
                size = "%6s / " % scale_bytes(torrent['available']) + size
            size = "%6s / " % scale_bytes(torrent['haveValid'] + torrent['haveUnchecked']) + size
        size = '| ' + size
        title = ljust_columns(torrent['name'], width - len(size)) + size

        if torrent['isIsolated']:
            color = curses.color_pair(self.colors.id('title_error'))
        elif torrent['status'] == Transmission.STATUS_SEED or \
           torrent['status'] == Transmission.STATUS_SEED_WAIT:
            color = curses.color_pair(self.colors.id('title_seed'))
        elif torrent['status'] == Transmission.STATUS_STOPPED:
            color = curses.color_pair(self.colors.id('title_paused'))
        elif torrent['status'] == Transmission.STATUS_CHECK or \
             torrent['status'] == Transmission.STATUS_CHECK_WAIT:
            color = curses.color_pair(self.colors.id('title_verify'))
        elif torrent['rateDownload'] == 0:
            color = curses.color_pair(self.colors.id('title_idle'))
        elif torrent['percentDone'] < 100:
            color = curses.color_pair(self.colors.id('title_download'))
        else:
            color = 0

        tag = curses.A_REVERSE
        tag_done = tag + color
        if focused:
            tag += curses.A_BOLD
            tag_done += curses.A_BOLD

        if self.torrentname_is_progressbar:
            # addstr() dies when you tell it to draw on the last column of the
            # terminal, so we have to catch this exception.
            try:
                self.pad.addstr(ypos, 0, self.enc(title[0:bar_width]), tag_done)
                self.pad.addstr(ypos, len_columns(title[0:bar_width]), self.enc(title[bar_width:]), tag)
            except:
                pass
        else:
            self.pad.addstr(ypos, 0, self.enc(title), tag_done)


    def draw_torrentlist_status(self, torrent, focused, ypos):
        peers = ''
        parts = [server.get_status(torrent)]

        if torrent['isIsolated'] and torrent['peersConnected'] <= 0:
            if not torrent['trackerStats']:
                parts[0] = "Unable to find peers without trackers and DHT disabled"
            else:
                tracker_errors = [tracker['lastAnnounceResult'] or tracker['lastScrapeResult']
                                  for tracker in torrent['trackerStats']]
                parts[0] = self.enc([te for te in tracker_errors if te][0])
        else:
            if torrent['status'] == Transmission.STATUS_CHECK:
                parts[0] += " (%d%%)" % int(float(torrent['recheckProgress']) * 100)
            elif torrent['status'] == Transmission.STATUS_DOWNLOAD:
                parts[0] += " (%d%%)" % torrent['percentDone']
            parts[0] = parts[0].ljust(20)

            # seeds and leeches will be appended right justified later
            peers  = "%5s seed%s " % (num2str(torrent['seeders']), ('s', ' ')[torrent['seeders']==1])
            peers += "%5s leech%s" % (num2str(torrent['leechers']), ('es', '  ')[torrent['leechers']==1])

            # show additional information if enough room
            if self.torrent_title_width - sum(map(lambda x: len(x), parts)) - len(peers) > 18:
                uploaded = scale_bytes(torrent['uploadedEver'])
                parts.append("%7s uploaded" % ('nothing',uploaded)[uploaded != '0B'])

            if self.torrent_title_width - sum(map(lambda x: len(x), parts)) - len(peers) > 22:
                parts.append("%4s peer%s connected" % (torrent['peersConnected'],
                                                       ('s',' ')[torrent['peersConnected'] == 1]))

        if focused: tags = curses.A_REVERSE + curses.A_BOLD
        else:       tags = 0

        remaining_space = self.torrent_title_width - sum(map(lambda x: len(x), parts), len(peers)) - 2
        delimiter = ' ' * int(remaining_space / (len(parts)))

        line = server.get_bandwidth_priority(torrent) + ' ' + delimiter.join(parts)

        # make sure the peers element is always right justified
        line += ' ' * int(self.torrent_title_width - len(line) - len(peers)) + peers
        self.pad.addstr(ypos+1, 0, line, tags)


    def draw_details(self):
        self.torrent_details = server.get_torrent_details()
        self.manage_layout()

        # details could need more space than the torrent list
        self.pad_height = max(50, len(self.torrent_details['files'])+10, (len(self.torrents)+1)*3, self.height)
        self.pad = curses.newpad(self.pad_height, self.width)

        # torrent name + progress bar
        self.draw_torrentlist_item(self.torrent_details, False, False, 0)

        # divider + menu
        menu_items = ['_Overview', "_Files", 'P_eers', '_Trackers', 'Pie_ces' ]
        xpos = int((self.width - sum(map(lambda x: len(x), menu_items))-len(menu_items)) / 2)
        for item in menu_items:
            self.pad.move(3, xpos)
            tags = curses.A_BOLD
            if menu_items.index(item) == self.details_category_focus:
                tags += curses.A_REVERSE
            title = item.split('_')
            self.pad.addstr(title[0], tags)
            self.pad.addstr(title[1][0], tags + curses.A_UNDERLINE)
            self.pad.addstr(title[1][1:], tags)
            xpos += len(item)+1

        # which details to display
        if self.details_category_focus == 0:
            self.draw_details_overview(5)
        elif self.details_category_focus == 1:
            self.draw_filelist(5)
        elif self.details_category_focus == 2:
            self.draw_peerlist(5)
        elif self.details_category_focus == 3:
            self.draw_trackerlist(5)
        elif self.details_category_focus == 4:
            self.draw_pieces_map(5)

        self.pad.refresh(0,0, 1,0, self.height-2,self.width)
        self.screen.refresh()


    def draw_details_overview(self, ypos):
        t = self.torrent_details
        info = []
        info.append(['Hash: ', "%s" % t['hashString']])
        info.append(['ID: ',   "%s" % t['id']])

        wanted = 0
        for i, file_info in enumerate(t['files']):
            if t['wanted'][i] == True: wanted += t['files'][i]['length']

        sizes = ['Size: ', "%s;  " % scale_bytes(t['totalSize'], 'long'),
                 "%s wanted;  " % (scale_bytes(wanted, 'long'),'everything') [t['totalSize'] == wanted]]
        if t['available'] < t['totalSize']:
            sizes.append("%s available;  " % scale_bytes(t['available'], 'long'))
        sizes.extend(["%s left" % scale_bytes(t['leftUntilDone'], 'long')])
        info.append(sizes)

        info.append(['Files: ', "%d;  " % len(t['files'])])
        complete     = map(lambda x: x['bytesCompleted'] == x['length'], t['files']).count(True)
        not_complete = filter(lambda x: x['bytesCompleted'] != x['length'], t['files'])
        partial      = map(lambda x: x['bytesCompleted'] > 0, not_complete).count(True)
        if complete == len(t['files']):
            info[-1].append("all complete")
        else:
            info[-1].append("%d complete;  " % complete)
            info[-1].append("%d commenced" % partial)

        info.append(['Pieces: ', "%s;  " % t['pieceCount'],
                     "%s each" % scale_bytes(t['pieceSize'], 'long')])

        info.append(['Download: '])
        info[-1].append("%s" % scale_bytes(t['downloadedEver'], 'long') + \
                        " (%d%%) received;  " % int(percent(t['sizeWhenDone'], t['downloadedEver'])))
        info[-1].append("%s" % scale_bytes(t['haveValid'], 'long') + \
                        " (%d%%) verified;  " % int(percent(t['sizeWhenDone'], t['haveValid'])))
        info[-1].append("%s corrupt"  % scale_bytes(t['corruptEver'], 'long'))
        if t['percentDone'] < 100:
            info[-1][-1] += ';  '
            if t['rateDownload']:
                info[-1].append("receiving %s per second" % scale_bytes(t['rateDownload'], 'long'))
                if t['downloadLimited']:
                    info[-1][-1] += " (throttled to %s)" % scale_bytes(t['downloadLimit']*1024, 'long')
            else:
                info[-1].append("no reception in progress")

        try:
            copies_distributed = (float(t['uploadedEver']) / float(t['sizeWhenDone']))
        except ZeroDivisionError:
            copies_distributed = 0
        info.append(['Upload: ', "%s (%d%%) transmitted; " %
                     (scale_bytes(t['uploadedEver'], 'long'), t['uploadRatio']*100)])
        if t['rateUpload']:
            info[-1].append("sending %s per second" % scale_bytes(t['rateUpload'], 'long'))
            if t['uploadLimited']:
                info[-1][-1] += " (throttled to %s)" % scale_bytes(t['uploadLimit']*1024, 'long')
        else:
            info[-1].append("no transmission in progress")

        info.append(['Ratio: ', '%.2f copies distributed' % copies_distributed])
        norm_upload_rate = norm.add('%s:rateUpload' % t['id'], t['rateUpload'], 50)
        if norm_upload_rate > 0:
            target_ratio = self.get_target_ratio()
            bytes_left   = (max(t['downloadedEver'],t['sizeWhenDone']) * target_ratio) - t['uploadedEver']
            time_left    = bytes_left / norm_upload_rate
            info[-1][-1] += ';  '
            if time_left < 86400:   # 1 day
                info[-1].append('approaching %.2f at %s' % \
                                    (target_ratio, timestamp(time.time() + time_left, "%R")))
            else:
                info[-1].append('approaching %.2f on %s' % \
                                    (target_ratio, timestamp(time.time() + time_left, "%x")))

        info.append(['Seed limit: '])
        if t['seedRatioMode'] == 0:
            if self.stats['seedRatioLimited']:
                info[-1].append('default (pause torrent after distributing %s copies)' % self.stats['seedRatioLimit'])
            else:
                info[-1].append('default (unlimited)')
        elif t['seedRatioMode'] == 1:
            info[-1].append('pause torrent after distributing %s copies' % t['seedRatioLimit'])
        elif t['seedRatioMode'] == 2:
            info[-1].append('unlimited (ignore global limits)')

        info.append(['Peers: ',
                     "connected to %d;  "     % t['peersConnected'],
                     "downloading from %d;  " % t['peersSendingToUs'],
                     "uploading to %d"        % t['peersGettingFromUs']])

        # average peer speed
        incomplete_peers = [peer for peer in self.torrent_details['peers'] if peer['progress'] < 1]
        if incomplete_peers:
            # use at least 2/3 or 10 of incomplete peers to make an estimation
            active_peers = [peer for peer in incomplete_peers if peer['download_speed']]
            min_active_peers = min(10, max(1, round(len(incomplete_peers)*0.666)))
            if 1 <= len(active_peers) >= min_active_peers:
                swarm_speed  = sum([peer['download_speed'] for peer in active_peers]) / len(active_peers)
                info.append(['Swarm speed: ', "%s on average;  " % scale_bytes(swarm_speed),
                             "distribution of 1 copy takes %s" % \
                                 scale_time(int(t['totalSize'] / swarm_speed), 'long')])
            else:
                info.append(['Swarm speed: ', "<gathering info from %d peers, %d done>" % \
                                 (min_active_peers, len(active_peers))])
        else:
            info.append(['Swarm speed: ', "<no downloading peers connected>"])


        info.append(['Privacy: '])
        if t['isPrivate']:
            info[-1].append('Private to this tracker -- DHT and PEX disabled')
        else:
            info[-1].append('Public torrent')

        info.append(['Location: ',"%s" % homedir2tilde(t['downloadDir'])])

        ypos = self.draw_details_list(ypos, info)

        self.draw_details_eventdates(ypos+1)
        return ypos+1

    def get_target_ratio(self):
        t = self.torrent_details
        if t['seedRatioMode'] == 1:
            return t['seedRatioLimit']              # individual limit
        elif t['seedRatioMode'] == 0 and self.stats['seedRatioLimited']:
            return self.stats['seedRatioLimit']     # global limit
        else:
            # round up to next 10/5/1
            if t['uploadRatio'] >= 100:
                step_size = 10.0
            elif t['uploadRatio'] >= 10:
                step_size = 5.0
            else:
                step_size = 1.0
            return int(round((t['uploadRatio'] + step_size/2) / step_size) * step_size)

    def draw_details_eventdates(self, ypos):
        t = self.torrent_details

        self.pad.addstr(ypos,   1, '  Created: ' + timestamp(t['dateCreated']))
        self.pad.addstr(ypos+1, 1, '    Added: ' + timestamp(t['addedDate']))
        self.pad.addstr(ypos+2, 1, '  Started: ' + timestamp(t['startDate']))
        self.pad.addstr(ypos+3, 1, ' Activity: ' + timestamp(t['activityDate']))

        if t['percentDone'] < 100 and t['eta'] > 0:
            self.pad.addstr(ypos+4, 1, 'Finishing: ' + timestamp(time.time() + t['eta']))
        elif t['doneDate'] <= 0:
            self.pad.addstr(ypos+4, 1, 'Finishing: sometime')
        else:
            self.pad.addstr(ypos+4, 1, ' Finished: ' + timestamp(t['doneDate']))

        if t['comment']:
            if self.width >= 90:
                width = self.width - 50
                comment = wrap_multiline(t['comment'], width, initial_indent='Comment: ')
                for i, line in enumerate(comment):
                    if(ypos+i > self.height-1):
                        break
                    self.pad.addstr(ypos+i, 50, self.enc(line))
            else:
                width = self.width - 2
                comment = wrap_multiline(t['comment'], width, initial_indent='Comment: ')
                for i, line in enumerate(comment):
                    self.pad.addstr(ypos+6+i, 2, self.enc(line))

    def draw_filelist(self, ypos):
        column_names = '  #  Progress  Size  Priority  Filename'
        self.pad.addstr(ypos, 0, column_names.ljust(self.width), curses.A_UNDERLINE)
        ypos += 1

        for line in self.create_filelist():
            curses_tags = 0
            # highlight focused/selected line(s)
            while line.startswith('_'):
                if line[1] == 'S':
                    curses_tags  = curses.A_BOLD
                    line = line[2:]
                if line[1] == 'F':
                    curses_tags += curses.A_REVERSE
                    line = line[2:]
                try:
                    self.pad.addstr(ypos, 0, ' '*self.width, curses_tags)
                except: pass

            # colored priority (only in the first 30 chars, the rest is filename)
            xpos = 0
            for part in re.split('(high|normal|low|off)', line[0:30], 1):
                if part == 'high':
                    self.pad.addstr(ypos, xpos, self.enc(part),
                                    curses_tags + curses.color_pair(self.colors.id('file_prio_high')))
                elif part == 'normal':
                    self.pad.addstr(ypos, xpos, self.enc(part),
                                    curses_tags + curses.color_pair(self.colors.id('file_prio_normal')))
                elif part == 'low':
                    self.pad.addstr(ypos, xpos, self.enc(part),
                                    curses_tags + curses.color_pair(self.colors.id('file_prio_low')))
                elif part == 'off':
                    self.pad.addstr(ypos, xpos, self.enc(part),
                                    curses_tags + curses.color_pair(self.colors.id('file_prio_off')))
                else:
                    self.pad.addstr(ypos, xpos, self.enc(part), curses_tags)
                xpos += len(part)
            self.pad.addstr(ypos, xpos, self.enc(line[30:]), curses_tags)
            ypos += 1
            if ypos > self.height:
                break

    def create_filelist(self):
        files = sorted(self.torrent_details['files'], cmp=lambda x,y: cmp(x['name'], y['name']))
        # Build new mapping between sorted local files and transmission-daemon's unsorted files
        self.file_index_map = {}
        for index,file in enumerate(files):
            self.file_index_map[index] = self.torrent_details['files'].index(file)

        filelist = []
        current_folder = []
        current_depth = 0
        pos = 0
        pos_before_focus = 0
        index = 0
        for file in files:
            f = file['name'].split('/')
            f_len = len(f) - 1
            if f[:f_len] != current_folder:
                [current_depth, pos] = self.create_filelist_transition(f, current_folder, filelist, current_depth, pos)
                current_folder = f[:f_len]
            filelist.append(self.create_filelist_line(f[-1], index, percent(file['length'], file['bytesCompleted']),
                file['length'], current_depth))
            index += 1
            if self.focus_detaillist == index - 1:
                pos_before_focus = pos
            if index + pos >= self.focus_detaillist + 1 + pos + self.detaillistitems_per_page/2 \
            and index + pos >= self.detaillistitems_per_page:
                if self.focus_detaillist + 1 + pos_before_focus < self.detaillistitems_per_page / 2:
                    return filelist
                return filelist[self.focus_detaillist + 1 + pos_before_focus - self.detaillistitems_per_page / 2
                        : self.focus_detaillist + 1 + pos_before_focus + self.detaillistitems_per_page / 2]
        begin = len(filelist) - self.detaillistitems_per_page
        return filelist[begin > 0 and begin or 0:]

    def create_filelist_transition(self, f, current_folder, filelist, current_depth, pos):
        """ Create directory transition from <current_folder> to <f>,
        both of which are an array of strings, each one representing one
        subdirectory in their path (e.g. /tmp/a/c would result in
        [temp, a, c]). <filelist> is a list of strings that will later be drawn
        to screen. This function only creates directory strings, and is
        responsible for managing depth (i.e. indentation) between different
        directories.
        """
        f_len = len(f) - 1  # Amount of subdirectories in f
        current_folder_len = len(current_folder)  # Amount of subdirectories in
                                                  # current_folder
        # Number of directory parts from f and current_directory that are identical
        same = 0
        while (same < current_folder_len and
               same < f_len and
               f[same] == current_folder[same]):
            same += 1

        # Reduce depth for each directory f has less than current_folder
        if self.blank_lines:
            for i in range(current_folder_len - same):
               current_depth -= 1
               filelist.append('  '*current_depth + ' '*31 + '/')
               pos += 1
        else: # code duplication, but less calculation
            for i in range(current_folder_len - same):
               current_depth -= 1

        # Stepping out of a directory, but not into a new directory
        if f_len < current_folder_len and f_len == same:
            return [current_depth, pos]

        # Increase depth for each new directory that appears in f,
        # but not in current_directory
        while current_depth < f_len:
            filelist.append('%s\\ %s' % ('  '*current_depth + ' '*31 , f[current_depth]))
            current_depth += 1
            pos += 1
        return [current_depth, pos]

    def create_filelist_line(self, name, index, percent, length, current_depth):
        line = "%s  %6.1f%%" % (str(index+1).rjust(3), percent) + \
            '  '+scale_bytes(length).rjust(5) + \
            '  '+server.get_file_priority(self.torrent_details['id'], self.file_index_map[index]).center(8) + \
            " %s| %s" % ('  '*current_depth, name[0:self.width-31-current_depth])
        if index == self.focus_detaillist:
            line = '_F' + line
        if index in self.selected_files:
            line = '_S' + line
        return line

    def draw_peerlist(self, ypos):
        # Start drawing list either at the "selected" index, or at the index
        # that is required to display all remaining items without further scrolling.
        last_possible_index = max(0, len(self.torrent_details['peers']) - self.detaillistitems_per_page)
        start = min(self.scrollpos_detaillist, last_possible_index)
        end = start + self.detaillistitems_per_page
        peers = self.torrent_details['peers'][start:end]

        # Find width of columns
        clientname_width = 0
        address_width = 0
        port_width = 0
        for peer in peers:
            if len(peer['clientName']) > clientname_width: clientname_width = len(peer['clientName'])
            if len(peer['address']) > address_width: address_width = len(peer['address'])
            if len(str(peer['port'])) > port_width: port_width = len(str(peer['port']))

        # Column names
        column_names = 'Flags %3d Down %3d Up Progress     ETA ' % \
            (self.torrent_details['peersSendingToUs'], self.torrent_details['peersGettingFromUs'])
        column_names += 'Client'.ljust(clientname_width + 1) \
            + 'Address'.ljust(address_width+port_width+1)
        if features['geoip']: column_names += 'Country'
        if features['dns']: column_names += ' Host'

        self.pad.addstr(ypos, 0, column_names.ljust(self.width), curses.A_UNDERLINE)
        ypos += 1

        # Peers
        hosts = server.get_hosts()
        geo_ips = server.get_geo_ips()
        for index, peer in enumerate(peers):
            if features['dns']:
                try:
                    try:
                        host = hosts[peer['address']].check()
                        host_name = host[3][0]
                    except (IndexError, KeyError):
                        host_name = "<not resolvable>"
                except adns.NotReady:
                    host_name = "<resolving>"
                except adns.Error, msg:
                    host_name = msg

            upload_tag = download_tag = line_tag = 0
            if peer['rateToPeer']:   upload_tag   = curses.A_BOLD
            if peer['rateToClient']: download_tag = curses.A_BOLD

            self.pad.move(ypos, 0)
            # Flags
            self.pad.addstr("%-6s   " % peer['flagStr'])
            # Down
            self.pad.addstr("%5s  " % scale_bytes(peer['rateToClient']), download_tag)
            # Up
            self.pad.addstr("%5s " % scale_bytes(peer['rateToPeer']), upload_tag)

            # Progress
            if peer['progress'] < 1: self.pad.addstr("%3d%%" % (float(peer['progress'])*100))
            else: self.pad.addstr("%3d%%" % (float(peer['progress'])*100), curses.A_BOLD)

            # ETA
            if peer['progress'] < 1 and peer['download_speed'] > 1024:
                self.pad.addstr(" %6s %4s " % \
                                    ('~' + scale_bytes(peer['download_speed']),
                                     '~' + scale_time(peer['time_left'])))
            else:
                if peer['progress'] < 1:
                    self.pad.addstr("  <guessing> ")
                else:
                    self.pad.addstr("             ")
            # Client
            self.pad.addstr(self.enc(peer['clientName'].ljust(clientname_width + 1)))
            # Address:Port
            self.pad.addstr(peer['address'].rjust(address_width) + \
                                ':' + str(peer['port']).ljust(port_width) + ' ')
            # Country
            if features['geoip']: self.pad.addstr("  %2s   " % geo_ips[peer['address']])
            # Host
            if features['dns']: self.pad.addstr(self.enc(host_name), curses.A_DIM)
            ypos += 1

    def draw_trackerlist(self, ypos):
        top = ypos - 1
        def addstr(ypos, xpos, *args):
            if ypos > top and ypos < self.height - 2:
                self.pad.addstr(ypos, xpos, *args)

        tracker_per_page = self.detaillistitems_per_page // self.TRACKER_ITEM_HEIGHT
        page = self.scrollpos_detaillist // tracker_per_page
        start = tracker_per_page * page
        end = tracker_per_page * (page + 1)
        tlist = self.torrent_details['trackerStats'][start:end]

        # keep position in range when last tracker gets deleted
        self.scrollpos_detaillist = min(self.scrollpos_detaillist,
                                        len(self.torrent_details['trackerStats'])-1)
        # show newly added tracker when list was empty before
        if self.torrent_details['trackerStats']:
            self.scrollpos_detaillist = max(0, self.scrollpos_detaillist)

        current_tier = -1
        for index, t in enumerate(tlist):
            announce_msg_size = scrape_msg_size = 0
            selected = t == self.torrent_details['trackerStats'][self.scrollpos_detaillist]

            if current_tier != t['tier']:
                current_tier = t['tier']

                tiercolor = curses.A_BOLD + curses.A_REVERSE \
                            if selected else curses.A_REVERSE
                addstr(ypos, 0, ("Tier %d" % (current_tier+1)).ljust(self.width), tiercolor)
                ypos += 1

            if selected:
                for i in range(4):
                    addstr(ypos+i, 0, ' ', curses.A_BOLD + curses.A_REVERSE)

            addstr(ypos+1, 4,  "Last announce: %s" % timestamp(t['lastAnnounceTime']))
            addstr(ypos+1, 54, "Last scrape: %s" % timestamp(t['lastScrapeTime']))

            if t['lastAnnounceSucceeded']:
                peers = "%s peer%s" % (num2str(t['lastAnnouncePeerCount']), ('s', '')[t['lastAnnouncePeerCount']==1])
                addstr(ypos,   2, t['announce'], curses.A_BOLD + curses.A_UNDERLINE)
                addstr(ypos+2, 11, "Result: ")
                addstr(ypos+2, 19, "%s received" % peers, curses.A_BOLD)
            else:
                addstr(ypos,   2, t['announce'], curses.A_UNDERLINE)
                addstr(ypos+2, 9, "Response:")
                announce_msg_size = self.wrap_and_draw_result(top, ypos+2, 19, self.enc(t['lastAnnounceResult']))

            if t['lastScrapeSucceeded']:
                seeds   = "%s seed%s" % (num2str(t['seederCount']), ('s', '')[t['seederCount']==1])
                leeches = "%s leech%s" % (num2str(t['leecherCount']), ('es', '')[t['leecherCount']==1])
                addstr(ypos+2, 52, "Tracker knows:")
                addstr(ypos+2, 67, "%s and %s" % (seeds, leeches), curses.A_BOLD)
            else:
                addstr(ypos+2, 57, "Response:")
                scrape_msg_size += self.wrap_and_draw_result(top, ypos+2, 67, t['lastScrapeResult'])

            ypos += max(announce_msg_size, scrape_msg_size)

            addstr(ypos+3, 4,  "Next announce: %s" % timestamp(t['nextAnnounceTime']))
            addstr(ypos+3, 52, "  Next scrape: %s" % timestamp(t['nextScrapeTime']))

            ypos += 5

    def wrap_and_draw_result(self, top, ypos, xpos, result):
        result = wrap(result, 30)
        i = 0
        for i, line in enumerate(result):
            if ypos+i > top and ypos+i < self.height - 2:
                self.pad.addstr(ypos+i, xpos, line, curses.A_UNDERLINE)
        return i


    def draw_pieces_map(self, ypos):
        pieces = self.torrent_details['pieces']
        piece_count = self.torrent_details['pieceCount']
        margin = len(str(piece_count)) + 2

        map_width = int(str(self.width-margin-1)[0:-1] + '0')
        for x in range(10, map_width, 10):
            self.pad.addstr(ypos, x+margin-1, str(x), curses.A_BOLD)

        start = self.scrollpos_detaillist * map_width
        end = min(start + (self.height - ypos - 3) * map_width, piece_count)
        if end <= start: return
        block = ord(pieces[start >> 3]) << (start & 7)

        format = "%%%dd" % (margin - 2)
        for counter in xrange(start, end):
            if counter % map_width == 0:
                ypos += 1 ; xpos = margin
                self.pad.addstr(ypos, 1, format % counter, curses.A_BOLD)
            else:
                xpos += 1

            if counter & 7 == 0:
                block = ord(pieces[counter >> 3])
            piece = block & 0x80
            if piece: self.pad.addch(ypos, xpos, ' ', curses.A_REVERSE)
            else:     self.pad.addch(ypos, xpos, '_')
            block <<= 1

        missing_pieces = piece_count - counter - 1
        if missing_pieces:
            line = "%d further piece%s" % (missing_pieces, ('','s')[missing_pieces>1])
            xpos = (self.width - len(line)) / 2
            self.pad.addstr(self.height-3, xpos, line, curses.A_REVERSE)

    def draw_details_list(self, ypos, info):
        key_width = max(map(lambda x: len(x[0]), info))
        for i in info:
            self.pad.addstr(ypos, 1, self.enc(i[0].rjust(key_width))) # key
            # value part may be wrapped if it gets too long
            for v in i[1:]:
                y, x = self.pad.getyx()
                if x + len(v) >= self.width:
                    ypos += 1
                    self.pad.move(ypos, key_width+1)
                self.pad.addstr(self.enc(v))
            ypos += 1
        return ypos

    def next_details(self):
        if self.details_category_focus >= 4:
            self.details_category_focus = 0
        else:
            self.details_category_focus += 1
        self.focus_detaillist     = -1
        self.scrollpos_detaillist = 0
        self.pad.erase()

    def prev_details(self):
        if self.details_category_focus <= 0:
            self.details_category_focus = 4
        else:
            self.details_category_focus -= 1
        self.pad.erase()




    def move_up(self, focus, scrollpos, step_size):
        if focus < 0: focus = -1
        else:
            focus -= 1
            if scrollpos/step_size - focus > 0:
                scrollpos -= step_size
                scrollpos = max(0, scrollpos)
            while scrollpos % step_size:
                scrollpos -= 1
        return focus, scrollpos

    def move_down(self, focus, scrollpos, step_size, elements_per_page, list_height):
        if focus < list_height - 1:
            focus += 1
            if focus+1 - scrollpos/step_size > elements_per_page:
                scrollpos += step_size
        return focus, scrollpos

    def move_page_up(self, focus, scrollpos, step_size, elements_per_page):
        for x in range(elements_per_page - 1):
            focus, scrollpos = self.move_up(focus, scrollpos, step_size)
        if focus < 0: focus = 0
        return focus, scrollpos

    def move_page_down(self, focus, scrollpos, step_size, elements_per_page, list_height):
        if focus < 0: focus = 0
        for x in range(elements_per_page - 1):
            focus, scrollpos = self.move_down(focus, scrollpos, step_size, elements_per_page, list_height)
        return focus, scrollpos

    def move_to_top(self):
        return 0, 0

    def move_to_end(self, step_size, elements_per_page, list_height):
        focus     = list_height - 1
        scrollpos = max(0, (list_height - elements_per_page) * step_size)
        return focus, scrollpos





    def draw_stats(self):
        self.screen.insstr(self.height-1, 0, ' '.center(self.width), curses.A_REVERSE)
        self.draw_torrents_stats()
        self.draw_global_rates()

    def draw_torrents_stats(self):
        if self.selected_torrent > -1 and self.details_category_focus == 2:
            self.screen.insstr((self.height-1), 0,
                               "%d peer%s connected (" % (self.torrent_details['peersConnected'],
                                                         ('s','')[self.torrent_details['peersConnected'] == 1]) + \
                                   "Trackers:%d " % self.torrent_details['peersFrom']['fromTracker'] + \
                                   "DHT:%d " % self.torrent_details['peersFrom']['fromDht'] + \
                                   "LTEP:%d " % self.torrent_details['peersFrom']['fromLtep'] + \
                                   "PEX:%d " % self.torrent_details['peersFrom']['fromPex'] + \
                                   "Incoming:%d " % self.torrent_details['peersFrom']['fromIncoming'] + \
                                   "Cache:%d)" % self.torrent_details['peersFrom']['fromCache'],
                               curses.A_REVERSE)
        else:
            self.screen.addstr((self.height-1), 0, "Torrent%s:" % ('s','')[len(self.torrents) == 1],
                                   curses.A_REVERSE)
            self.screen.addstr("%d (" % len(self.torrents), curses.A_REVERSE)

            downloading = len(filter(lambda x: x['status']==Transmission.STATUS_DOWNLOAD, self.torrents))
            seeding = len(filter(lambda x: x['status']==Transmission.STATUS_SEED, self.torrents))
            paused = self.stats['pausedTorrentCount']

            self.screen.addstr("Downloading:", curses.A_REVERSE)
            self.screen.addstr("%d " % downloading, curses.A_REVERSE)
            self.screen.addstr("Seeding:", curses.A_REVERSE)
            self.screen.addstr("%d " % seeding, curses.A_REVERSE)
            self.screen.addstr("Paused:", curses.A_REVERSE)
            self.screen.addstr("%d) " % paused, curses.A_REVERSE)

            if self.filter_list:
                self.screen.addstr("Filter:", curses.A_REVERSE)
                self.screen.addstr("%s%s" % (('','not ')[self.filter_inverse], self.filter_list),
                                   curses.color_pair(self.colors.id('filter_status'))
                                   + curses.A_REVERSE)

            # show last sort order (if terminal size permits it)
            curpos_y, curpos_x = self.screen.getyx()
            if self.sort_orders and self.width - curpos_x > 20:
                self.screen.addstr(" Sort by:", curses.A_REVERSE)
                name = [name[1] for name in self.sort_options if name[0] == self.sort_orders[-1]['name']][0]
                name = name.replace('_', '').lower()
                curses_tags = curses.color_pair(self.colors.id('filter_status')) + curses.A_REVERSE
                if self.sort_orders[-1]['reverse']:
                    self.screen.addch(curses.ACS_DARROW, curses_tags)
                else:
                    self.screen.addch(curses.ACS_UARROW, curses_tags)
                try:  # 'name' may be too long
                    self.screen.addstr(name, curses_tags)
                except curses.error:
                    pass

    def draw_global_rates(self):
        rates_width = self.rateDownload_width + self.rateUpload_width + 3

        if self.stats['alt-speed-enabled']:
            upload_limit   = "/%dK" % self.stats['alt-speed-up']
            download_limit = "/%dK" % self.stats['alt-speed-down']
        else:
            upload_limit   = ('', "/%dK" % self.stats['speed-limit-up'])[self.stats['speed-limit-up-enabled']]
            download_limit = ('', "/%dK" % self.stats['speed-limit-down'])[self.stats['speed-limit-down-enabled']]

        limits = {'dn_limit' : download_limit, 'up_limit' : upload_limit}
        limits_width = len(limits['dn_limit']) + len(limits['up_limit'])

        if self.stats['alt-speed-enabled']:
            self.screen.move(self.height-1, self.width-rates_width - limits_width - len('Turtle mode '))
            self.screen.addstr('Turtle mode', curses.A_REVERSE + curses.A_BOLD)
            self.screen.addch(' ', curses.A_REVERSE)

        self.screen.move(self.height - 1, self.width - rates_width - limits_width)
        self.screen.addch(curses.ACS_DARROW, curses.A_REVERSE)
        self.screen.addstr(scale_bytes(self.stats['downloadSpeed']).rjust(self.rateDownload_width),
                           curses.color_pair(self.colors.id('download_rate'))
                           + curses.A_REVERSE + curses.A_BOLD)
        self.screen.addstr(limits['dn_limit'], curses.A_REVERSE)
        self.screen.addch(' ', curses.A_REVERSE)
        self.screen.addch(curses.ACS_UARROW, curses.A_REVERSE)
        self.screen.insstr(limits['up_limit'], curses.A_REVERSE)
        self.screen.insstr(scale_bytes(self.stats['uploadSpeed']).rjust(self.rateUpload_width),
                           curses.color_pair(self.colors.id('upload_rate'))
                           + curses.A_REVERSE + curses.A_BOLD)



    def draw_title_bar(self):
        self.screen.insstr(0, 0, ' '.center(self.width), curses.A_REVERSE)
        self.draw_connection_status()
        self.draw_quick_help()
    def draw_connection_status(self):
        status = "Transmission @ %s:%s" % (server.host, server.port)
        if cmd_args.DEBUG:
            status = "%d x %d " % (self.width, self.height) + status
        self.screen.addstr(0, 0, self.enc(status), curses.A_REVERSE)

    def draw_quick_help(self):
        help = [('?','Show Keybindings')]

        if self.selected_torrent == -1:
            if self.focus >= 0:
                help = [('enter','View Details'), ('p','Pause/Unpause'), ('r','Remove'), ('v','Verify')]
            else:
                help = [('/','Search'), ('f','Filter'), ('s','Sort')] + help + [('o','Options'), ('q','Quit')]
        else:
            help = [('Move with','cursor keys'), ('q','Back to List')]
            if self.details_category_focus == 1 and self.focus_detaillist > -1:
                help = [('enter', 'Open File'),
                        ('space','(De)Select File'),
                        ('left/right','De-/Increase Priority'),
                        ('escape','Unfocus/-select')] + help
            elif self.details_category_focus == 2:
                help = [('F1/?','Explain flags')] + help
            elif self.details_category_focus == 3:
                help = [('a','Add Tracker'),('r','Remove Tracker')] + help

        line = ' | '.join(map(lambda x: "%s %s" % (x[0], x[1]), help))
        line = line[0:self.width]
        self.screen.insstr(0, self.width-len(line), line, curses.A_REVERSE)


    def list_key_bindings(self):
        title = 'Help Menu'
        message = "           F1/?  Show this help\n" + \
                  "            u/d  Adjust maximum global up-/download rate\n" + \
                  "            U/D  Adjust maximum up-/download rate for focused torrent\n" + \
                  "              L  Set seed ratio limit for focused torrent\n" + \
                  "            +/-  Adjust bandwidth priority for focused torrent\n" + \
                  "              p  Pause/Unpause torrent\n" + \
                  "              P  Pause/Unpause all torrents\n" + \
                  "            v/y  Verify torrent\n" + \
                  "              m  Move torrent\n" + \
                  "              n  Reannounce torrent\n" + \
                  "              a  Add torrent\n" + \
                  "          Del/r  Remove torrent and keep content\n" + \
                  "    Shift+Del/R  Remove torrent and delete content\n"

        # Queue was implemented in Transmission v2.4
        if server.get_rpc_version() >= 14 and self.details_category_focus != 1:
            message += "            J/K  Move focused torrent in queue up/down\n" + \
                       " Shift+Lft/Rght  Move focused torrent in queue up/down by 10\n" + \
                       " Shift+Home/End  Move focused torrent to top/bottom of queue\n"
        else:
            message += "            J/K  Jump to next/previous directory\n"
        # Torrent list
        if self.selected_torrent == -1:
            message += "              /  Search in torrent list\n" + \
                       "              f  Filter torrent list\n" + \
                       "              s  Sort torrent list\n" \
                       "    Enter/Right  View torrent's details\n" + \
                       "              o  Configuration options\n" + \
                       "              t  Toggle turtle mode\n" + \
                       "              C  Toggle compact list mode\n" + \
                       "            Esc  Unfocus\n" + \
                       "              q  Quit"
        else:
            # Peer list
            if self.details_category_focus == 2:
                title = 'Peer status flags'
                message = " O  Optimistic unchoke\n" + \
                          " D  Downloading from this peer\n" + \
                          " d  We would download from this peer if they'd let us\n" + \
                          " U  Uploading to peer\n" + \
                          " u  We would upload to this peer if they'd ask\n" + \
                          " K  Peer has unchoked us, but we're not interested\n" + \
                          " ?  We unchoked this peer, but they're not interested\n" + \
                          " E  Encrypted Connection\n" + \
                          " H  Peer was discovered through DHT\n" + \
                          " X  Peer was discovered through Peer Exchange (PEX)\n" + \
                          " I  Peer is an incoming connection\n" + \
                          " T  Peer is connected via uTP"
            else:
                # Viewing torrent details
                message += "              o  Jump to overview\n" + \
                           "              f  Jump to file list\n" + \
                           "              e  Jump to peer list\n" + \
                           "              t  Jump to tracker information\n" + \
                           "      Tab/Right  Jump to next view\n" + \
                           " Shift+Tab/Left  Jump to previous view\n"
                if self.details_category_focus == 1:  # files
                    if self.focus_detaillist > -1:
                        message += "     Left/Right  Decrease/Increase file priority\n"
                    message += "        Up/Down  Select file\n" + \
                               "          Space  Select/Deselect focused file\n" + \
                               "              a  Select/Deselect all files\n" + \
                               "              A  Select/Deselect directory\n" + \
                               "            Esc  Unfocus+Unselect or Back to torrent list\n" + \
                               "    q/Backspace  Back to torrent list"
                else:
                    message += "q/Backspace/Esc  Back to torrent list"

        width  = max(map(lambda x: len(x), message.split("\n"))) + 4
        width  = min(self.width, width)
        height = min(self.height, message.count("\n")+3)
        win = self.window(height, width, message=message, title=title)
        while True:
            if win.getch() >= 0: return


    def window(self, height, width, message='', title=''):
        height = min(self.height, height)
        width  = min(self.width, width)
        ypos = int( (self.height - height) / 2 )
        xpos = int( (self.width  - width) / 2 )
        win = curses.newwin(height, width, ypos, xpos)
        win.box()
        win.bkgd(' ', curses.A_REVERSE + curses.A_BOLD)

        if width >= 20:
            win.addch(height-1, width-19, curses.ACS_RTEE)
            win.addstr(height-1, width-18, " Close with Esc ")
            win.addch(height-1, width-2, curses.ACS_LTEE)

        if width >= (len(title) + 6) and title != '':
            win.addch(0, 1, curses.ACS_RTEE)
            win.addstr(0, 2, " " + title + " ")
            win.addch(0, len(title) + 4 , curses.ACS_LTEE)

        ypos = 1
        for line in message.split("\n"):
            if len_columns(line) > width:
                line = ljust_columns(line, width-7) + '...'

            if ypos < height - 1:  # ypos == height-1 is frame border
                win.addstr(ypos, 2, self.enc(line))
                ypos += 1
            else:
                # Do not write outside of frame border
                win.addstr(ypos, 2, " More... ")
                break
        return win


    def dialog_ok(self, message):
        height = 3 + message.count("\n")
        width  = max(max(map(lambda x: len_columns(x), message.split("\n"))), 40) + 4
        win = self.window(height, width, message=message)
        while True:
            if win.getch() >= 0: return

    def dialog_yesno(self, message, important=False):
        height = 5 + message.count("\n")
        width  = max(len_columns(message), 8) + 4
        win = self.window(height, width, message=message)
        win.keypad(True)

        if important:
            win.bkgd(' ', curses.color_pair(self.colors.id('dialog_important'))
                          + curses.A_REVERSE)

        focus_tags   = curses.color_pair(self.colors.id('button_focused'))
        unfocus_tags = 0

        input = False
        while True:
            win.move(height-2, (width/2)-4)
            if input:
                win.addstr('Y',  focus_tags + curses.A_UNDERLINE)
                win.addstr('es', focus_tags)
                win.addstr('   ')
                win.addstr('N',  curses.A_UNDERLINE)
                win.addstr('o')
            else:
                win.addstr('Y', curses.A_UNDERLINE)
                win.addstr('es')
                win.addstr('   ')
                win.addstr('N',  focus_tags + curses.A_UNDERLINE)
                win.addstr('o', focus_tags)

            c = win.getch()
            if c == ord('y'):
                return True
            elif c == ord('n'):
                return False
            elif c == ord("\t"):
                input = not input
            elif c == curses.KEY_LEFT or c == ord('h'):
                input = True
            elif c == curses.KEY_RIGHT or c == ord('l'):
                input = False
            elif c == ord("\n") or c == ord(' '):
                return input
            elif c == 27 or c == curses.KEY_BREAK:
                return -1


    # tab_complete values:
    #               'all': complete with any files/directories
    #              'dirs': complete only with directories
    #     any false value: do not complete
    def dialog_input_text(self, message, input='', on_change=None, on_enter=None, tab_complete=None):
        width  = self.width - 4
        textwidth = self.width - 8
        height = message.count("\n") + 4

        win = self.window(height, width, message=message)
        win.keypad(True)
        show_cursor()
        index = len(input)
        while True:
            # Cut the text into pages, each as long as the text field
            # The current page is determined by index position
            page = index // textwidth
            displaytext = input[textwidth*page:textwidth*(page + 1)]
            displayindex = index - textwidth*page

            color = (curses.color_pair(self.colors.id('dialog_important')) if self.highlight_dialog
                     else curses.color_pair(self.colors.id('dialog')))
            win.addstr(height - 2, 2, displaytext.ljust(textwidth), color)
            win.move(height - 2, displayindex + 2)
            c = win.getch()
            if c == 27 or c == curses.KEY_BREAK:
                hide_cursor()
                return ''
            elif index < len(input) and ( c == curses.KEY_RIGHT or c == curses.ascii.ctrl(ord('f')) ):
                index += 1
            elif index > 0 and ( c == curses.KEY_LEFT or c == curses.ascii.ctrl(ord('b')) ):
                index -= 1
            elif (c == curses.KEY_BACKSPACE or c == 127) and index > 0:
                input = input[:index - 1] + (index < len(input) and input[index:] or '')
                index -= 1
                if on_change: on_change(input)
            elif index < len(input) and ( c == curses.KEY_DC or c == curses.ascii.ctrl(ord('d')) ):
                input = input[:index] + input[index + 1:]
                if on_change: on_change(input)
            elif index < len(input) and c == curses.ascii.ctrl(ord('k')):
                input = input[:index]
                if on_change: on_change(input)
            elif c == curses.ascii.ctrl(ord('u')):
                # Delete from cursor until beginning of line
                input = input[index:]
                index = 0
                if on_change: on_change(input)
            elif c == curses.KEY_HOME or c == curses.ascii.ctrl(ord('a')):
                index = 0
            elif c == curses.KEY_END or c == curses.ascii.ctrl(ord('e')):
                index = len(input)
            elif c == ord('\n'):
                if on_enter:
                    on_enter(input)
                else:
                    hide_cursor()
                    return input
            elif c >= 32 and c < 127:
                input = input[:index] + chr(c) + (index < len(input) and input[index:] or '')
                index += 1
                if on_change: on_change(input)
            elif c == ord('\t') and tab_complete:
                possible_choices = glob.glob(tilde2homedir(input)+'*')
                if tab_complete == 'dirs':
                    possible_choices = [ d for d in possible_choices if os.path.isdir(d) ]
                if(possible_choices):
                    input = os.path.commonprefix(possible_choices)
                    if len(possible_choices) == 1 and os.path.isdir(input) and input.endswith(os.sep) == False:
                        input += os.sep
                    input = homedir2tilde(input)
                    index = len(input)
            if on_change: win.redrawwin()

    def dialog_search_torrentlist(self, c):
        self.dialog_input_text('Search torrent by title:',
                               on_change=self.draw_torrent_list,
                               on_enter=self.increment_search)

    def increment_search(self, input):
        self.search_focus += 1
        self.draw_torrent_list(input)


    def dialog_input_number(self, message, current_value,
                            cursorkeys=True, floating_point=False, allow_empty=False,
                            allow_zero=True, allow_negative_one=True):
        if not allow_zero:
            allow_negative_one = False

        width  = max(max(map(lambda x: len(x), message.split("\n"))), 40) + 4
        width  = min(self.width, width)
        height = message.count("\n") + (4,6)[cursorkeys]

        show_cursor()
        win = self.window(height, width, message=message)
        win.keypad(True)
        input = str(current_value)
        if cursorkeys:
            if floating_point:
                bigstep   = 1
                smallstep = 0.1
            else:
                bigstep   = 100
                smallstep = 10
            win.addstr(height-4, 2, ("   up/down +/- %-3s" % bigstep).rjust(width-4))
            win.addstr(height-3, 2, ("left/right +/- %3s" % smallstep).rjust(width-4))
            if allow_negative_one:
                win.addstr(height-3, 2, "-1 means unlimited")
            if allow_empty:
                win.addstr(height-4, 2, "leave empty for default")

        while True:
            win.addstr(height-2, 2, input.ljust(width-4), curses.color_pair(self.colors.id('dialog')))
            win.move(height - 2, len(input) + 2)
            c = win.getch()
            if c == 27 or c == ord('q') or c == curses.KEY_BREAK:
                hide_cursor()
                return -128
            elif c == ord("\n"):
                try:
                    if allow_empty and len(input) <= 0:
                        hide_cursor()
                        return -2
                    elif floating_point:
                        hide_cursor()
                        return float(input)
                    else:
                        hide_cursor()
                        return int(input)
                except ValueError:
                    hide_cursor()
                    return -1

            elif c == curses.KEY_BACKSPACE or c == curses.KEY_DC or c == 127 or c == 8:
                input = input[:-1]
            elif len(input) >= width-5:
                curses.beep()
            elif c >= ord('1') and c <= ord('9'):
                input += chr(c)
            elif allow_zero and c == ord('0') and input != '-' and not input.startswith('0'):
                input += chr(c)
            elif allow_negative_one and c == ord('-') and len(input) == 0:
                input += chr(c)
            elif floating_point and c == ord('.') and not '.' in input:
                input += chr(c)

            elif cursorkeys and c != -1:
                try:
                    if input == '': input = 0
                    if floating_point: number = float(input)
                    else:              number = int(input)
                    if c == curses.KEY_LEFT or c == ord('h'):    number -= smallstep
                    elif c == curses.KEY_RIGHT or c == ord('l'): number += smallstep
                    elif c == curses.KEY_DOWN or c == ord('j'):  number -= bigstep
                    elif c == curses.KEY_UP or c == ord('k'):    number += bigstep
                    if not allow_zero and number <= 0:
                        number = 1
                    elif not allow_negative_one and number < 0:
                        number = 0
                    elif number < 0:  # input like -0.6 isn't useful
                        number = -1
                    input = str(number)
                except ValueError:
                    pass

    def dialog_menu(self, title, options, focus=1):
        height = len(options) + 2
        width  = max(max(map(lambda x: len(x[1])+3, options)), len(title)+3)
        win = self.window(height, width)

        win.addstr(0,1, title)
        win.keypad(True)

        old_focus = focus
        while True:
            keymap = self.dialog_list_menu_options(win, width, options, focus)
            c = win.getch()

            if c > 96 and c < 123 and chr(c) in keymap:
                return options[keymap[chr(c)]][0]
            elif c == 27 or c == ord('q'):
                return -128
            elif c == ord("\n"):
                return options[focus-1][0]
            elif c == curses.KEY_DOWN or c == ord('j') or c == curses.ascii.ctrl(ord('n')):
                focus += 1
                if focus > len(options): focus = 1
            elif c == curses.KEY_UP or c == ord('k') or c == curses.ascii.ctrl(ord('p')):
                focus -= 1
                if focus < 1: focus = len(options)
            elif c == curses.KEY_HOME or c == ord('g'):
                focus = 1
            elif c == curses.KEY_END or c == ord('G'):
                focus = len(options)

    def dialog_list_menu_options(self, win, width, options, focus):
        keys = dict()
        i = 1
        for option in options:
            title = option[1].split('_')
            if i == focus: tag = curses.color_pair(self.colors.id('dialog'))
            else:          tag = 0
            win.addstr(i,2, title[0], tag)
            win.addstr(title[1][0], tag + curses.A_UNDERLINE)
            win.addstr(title[1][1:], tag)
            win.addstr(''.ljust(width - len(option[1]) - 3), tag)

            keys[title[1][0].lower()] = i-1
            i+=1
        return keys

    def draw_options_dialog(self):
        enc_options = [('required','_required'), ('preferred','_preferred'), ('tolerated','_tolerated')]
        seed_ratio = self.stats['seedRatioLimit']
        while True:
            options = []
            options.append(('Peer _Port', "%d" % self.stats['peer-port']))
            options.append(('UP_nP/NAT-PMP', ('disabled','enabled ')[self.stats['port-forwarding-enabled']]))
            options.append(('Peer E_xchange', ('disabled','enabled ')[self.stats['pex-enabled']]))
            options.append(('_Distributed Hash Table', ('disabled','enabled ')[self.stats['dht-enabled']]))
            options.append(('_Local Peer Discovery', ('disabled','enabled ')[self.stats['lpd-enabled']]))
            options.append(('Protocol En_cryption', "%s" % self.stats['encryption']))
            # uTP support was added in Transmission v2.3
            if server.get_rpc_version() >= 13:
                options.append(('_Micro Transport Protocol', ('disabled','enabled')[self.stats['utp-enabled']]))
            options.append(('_Global Peer Limit', "%d" % self.stats['peer-limit-global']))
            options.append(('Peer Limit per _Torrent', "%d" % self.stats['peer-limit-per-torrent']))
            options.append(('T_urtle Mode UL Limit', "%dK" % self.stats['alt-speed-up']))
            options.append(('Tu_rtle Mode DL Limit', "%dK" % self.stats['alt-speed-down']))
            options.append(('_Seed Ratio Limit', "%s" % ('unlimited',self.stats['seedRatioLimit'])[self.stats['seedRatioLimited']]))
            # queue was implemented in Transmission v2.4
            if server.get_rpc_version() >= 14:
                options.append(('Do_wnload Queue Size', "%s" % ('disabled',self.stats['download-queue-size'])[self.stats['download-queue-enabled']]))
                options.append(('S_eed Queue Size', "%s" % ('disabled',self.stats['seed-queue-size'])[self.stats['seed-queue-enabled']]))
            options.append(('Title is Progress _Bar', ('no','yes')[self.torrentname_is_progressbar]))
            options.append(('Blan_k lines in non-compact', ('no','yes')[self.blank_lines]))
            options.append(('File _Viewer', "%s" % self.file_viewer))


            max_len = max([sum([len(re.sub('_', '', x)) for x in y[0]]) for y in options])
            win_width = min(max(len(self.file_viewer)+5, 15), self.width+max_len)
            win = self.window(len(options)+2, max_len+win_width, '', "Global Options")

            line_num = 1
            for option in options:
                parts = re.split('_', option[0])
                parts_len = sum([len(x) for x in parts])

                win.addstr(line_num, max_len-parts_len+2, parts.pop(0))
                for part in parts:
                    win.addstr(part[0], curses.A_UNDERLINE)
                    win.addstr(part[1:] + ': ' + option[1])
                line_num += 1

            c = win.getch()
            if c == 27 or c == ord('q') or c == ord("\n"):
                return
            elif c == ord('p'):
                port = self.dialog_input_number("Port for incoming connections",
                                                self.stats['peer-port'],
                                                cursorkeys=False)
                if port >= 0 and port <= 65535:
                    server.set_option('peer-port', port)
                elif port != -128:  # user hit ESC
                    self.dialog_ok('Port must be in the range of 0 - 65535')
            elif c == ord('n'):
                server.set_option('port-forwarding-enabled',
                                       (1,0)[self.stats['port-forwarding-enabled']])
            elif c == ord('x'):
                server.set_option('pex-enabled', (1,0)[self.stats['pex-enabled']])
            elif c == ord('d'):
                server.set_option('dht-enabled', (1,0)[self.stats['dht-enabled']])
            elif c == ord('l'):
                server.set_option('lpd-enabled', (1,0)[self.stats['lpd-enabled']])
            # uTP support was added in Transmission v2.3
            elif c == ord('m') and server.get_rpc_version() >= 13:
                server.set_option('utp-enabled', (1,0)[self.stats['utp-enabled']])
            elif c == ord('g'):
                limit = self.dialog_input_number("Maximum number of connected peers",
                                                 self.stats['peer-limit-global'],
                                                 allow_negative_one=False)
                if limit >= 0:
                    server.set_option('peer-limit-global', limit)
            elif c == ord('t'):
                limit = self.dialog_input_number("Maximum number of connected peers per torrent",
                                                 self.stats['peer-limit-per-torrent'],
                                                 allow_negative_one=False)
                if limit >= 0:
                    server.set_option('peer-limit-per-torrent', limit)
            elif c == ord('s'):
                limit = self.dialog_input_number('Stop seeding with upload/download ratio',
                                                 (-1,self.stats['seedRatioLimit'])[self.stats['seedRatioLimited']],
                                                 floating_point=True)
                if limit >= 0:
                    server.set_option('seedRatioLimit', limit)
                    server.set_option('seedRatioLimited', True)
                elif limit < 0 and limit != -128:
                    server.set_option('seedRatioLimited', False)
            elif c == ord('c'):
                choice = self.dialog_menu('Encryption', enc_options,
                                          map(lambda x: x[0]==self.stats['encryption'], enc_options).index(True)+1)
                if choice != -128:
                    server.set_option('encryption', choice)
            elif c == ord('u'):
                limit = self.dialog_input_number('Upload limit for Turtle Mode in kilobytes per second',
                                                 self.stats['alt-speed-up'],
                                                 allow_negative_one=False)
                if limit != -128:
                    server.set_option('alt-speed-up', limit)
            elif c == ord('r'):
                limit = self.dialog_input_number('Download limit for Turtle Mode in kilobytes per second',
                                                 self.stats['alt-speed-down'],
                                                 allow_negative_one=False)
                if limit != -128:
                    server.set_option('alt-speed-down', limit)
            elif c == ord('b'):
                self.torrentname_is_progressbar = not self.torrentname_is_progressbar
            # Queue was implemmented in Transmission v2.4
            elif c == ord('w') and server.get_rpc_version() >= 14:
                queue_size = self.dialog_input_number('Download Queue size',
                                                      (0, self.stats['download-queue-size'])[self.stats['download-queue-enabled']],
                                                      allow_negative_one = False)
                if queue_size != -128:
                    if queue_size == 0:
                        server.set_option('download-queue-enabled', False)
                    elif queue_size > 0:
                        if not self.stats['download-queue-enabled']:
                            server.set_option('download-queue-enabled', True)
                        server.set_option('download-queue-size', queue_size)
            # Queue was implemmented in Transmission v2.4
            elif c == ord('e') and server.get_rpc_version() >= 14:
                queue_size = self.dialog_input_number('Seed Queue size',
                                                      (0, self.stats['seed-queue-size'])[self.stats['seed-queue-enabled']],
                                                      allow_negative_one = False)
                if queue_size != -128:
                    if queue_size == 0:
                        server.set_option('seed-queue-enabled', False)
                    elif queue_size > 0:
                        if not self.stats['seed-queue-enabled']:
                            server.set_option('seed-queue-enabled', True)
                        server.set_option('seed-queue-size', queue_size)

            elif c == ord('k'):
		self.blank_lines = not self.blank_lines

            elif c == ord('v'):
                viewer = self.dialog_input_text('File Viewer\nExample: xdg-viewer %s', self.file_viewer)
                if viewer:
                    config.set('Misc', 'file_viewer', viewer.replace('%s','%%s'))
                    self.file_viewer=viewer

            self.draw_torrent_list()

# End of class Interface



def percent(full, part):
    try: percent = 100/(float(full) / float(part))
    except ZeroDivisionError: percent = 0.0
    return percent


def scale_time(seconds, type='short'):
    minute_in_sec = float(60)
    hour_in_sec   = float(3600)
    day_in_sec    = float(86400)
    month_in_sec  = 27.321661 * day_in_sec # from wikipedia
    year_in_sec   = 365.25    * day_in_sec # from wikipedia

    if seconds < 0:
        return ('?', 'some time')[type=='long']

    elif seconds < minute_in_sec:
        if type == 'long':
            if seconds < 5:
                return 'now'
            else:
                return "%d second%s" % (seconds, ('', 's')[seconds>1])
        else:
            return "%ds" % seconds

    elif seconds < hour_in_sec:
        minutes = round(seconds / minute_in_sec, 0)
        if type == 'long':
            return "%d minute%s" % (minutes, ('', 's')[minutes>1])
        else:
            return "%dm" % minutes

    elif seconds < day_in_sec:
        hours = round(seconds / hour_in_sec, 0)
        if type == 'long':
            return "%d hour%s" % (hours, ('', 's')[hours>1])
        else:
            return "%dh" % hours

    elif seconds < month_in_sec:
        days = round(seconds / day_in_sec, 0)
        if type == 'long':
            return "%d day%s" % (days, ('', 's')[days>1])
        else:
            return "%dd" % days

    elif seconds < year_in_sec:
        months = round(seconds / month_in_sec, 0)
        if type == 'long':
            return "%d month%s" % (months, ('', 's')[months>1])
        else:
            return "%dM" % months

    else:
        years = round(seconds / year_in_sec, 0)
        if type == 'long':
            return "%d year%s" % (years, ('', 's')[years>1])
        else:
            return "%dy" % years


def timestamp(timestamp, format="%x %X"):
    if timestamp < 1:
        return 'never'

    if timestamp > 2147483647:  # Max value of 32bit signed integer (2^31-1)
        # Timedelta objects do not fail on timestamps
        # resulting in a date later than 2038
        date = (datetime.datetime.fromtimestamp(0) +
                datetime.timedelta(seconds=timestamp))
        timeobj = date.timetuple()
    else:
        timeobj = time.localtime(timestamp)

    absolute = time.strftime(format, timeobj)
    if timestamp > time.time():
        relative = 'in ' + scale_time(int(timestamp - time.time()), 'long')
    else:
        relative = scale_time(int(time.time() - timestamp), 'long') + ' ago'

    if relative.startswith('now') or relative.endswith('now'):
        relative = 'now'
    return "%s (%s)" % (absolute, relative)


def scale_bytes(bytes, type='short'):
    if bytes >= 1073741824:
        scaled_bytes = round((bytes / 1073741824.0), 2)
        unit = 'G'
    elif bytes >= 1048576:
        scaled_bytes = round((bytes / 1048576.0), 1)
        if scaled_bytes >= 100:
            scaled_bytes = int(scaled_bytes)
        unit = 'M'
    elif bytes >= 1024:
        scaled_bytes = int(bytes / 1024)
        unit = 'K'
    else:
        scaled_bytes = round((bytes / 1024.0), 1)
        unit = 'K'


    # handle 0 bytes special
    if bytes == 0 and type == 'long':
        return 'nothing'

    # convert to integer if .0
    if int(scaled_bytes) == float(scaled_bytes):
        scaled_bytes = str(int(scaled_bytes))
    else:
        scaled_bytes = str(scaled_bytes).rstrip('0')

    if type == 'long':
        return num2str(bytes) + ' [' + scaled_bytes + unit + ']'
    else:
        return scaled_bytes + unit


def homedir2tilde(path):
    return re.sub(r'^'+os.environ['HOME'], '~', path)
def tilde2homedir(path):
    return re.sub(r'^~', os.environ['HOME'], path)

def html2text(str):
    str = re.sub(r'</h\d+>', "\n", str)
    str = re.sub(r'</p>', ' ', str)
    str = re.sub(r'<[^>]*?>', '', str)
    return str

def hide_cursor():
    try: curses.curs_set(0)   # hide cursor if possible
    except curses.error: pass # some terminals seem to have problems with that
def show_cursor():
    try: curses.curs_set(1)
    except curses.error: pass

def wrap_multiline(text, width, initial_indent='', subsequent_indent=None):
    if subsequent_indent is None:
        subsequent_indent = ' ' * len(initial_indent)
    for line in text.splitlines():
        # this is required because wrap() strips empty lines
        if not line.strip():
            yield line
            continue
        for line in wrap(line, width, replace_whitespace=False,
                initial_indent=initial_indent, subsequent_indent=subsequent_indent):
            yield line
        initial_indent = subsequent_indent

def ljust_columns(text, max_width, padchar=' '):
    """ Returns a string that is exactly <max_width> display columns wide,
    padded with <padchar> if necessary. Accounts for characters that are
    displayed two columns wide, i.e. kanji. """

    chars = []
    columns = 0
    max_width = max(0, max_width)
    for character in text:
        width = len_columns(character)
        if columns + width <= max_width:
            chars.append(character)
            columns += width
        else:
            break

    # Fill up any remaining space
    while columns < max_width:
        assert len(padchar) == 1
        chars.append(padchar)
        columns += 1
    return ''.join(chars)

def len_columns(text):
    """ Returns the amount of columns that <text> would occupy. """
    if type(text) == type(str()):
        text = unicode(text)
    columns = 0
    for character in text:
        columns += 2 if unicodedata.east_asian_width(character) in ('W', 'F') else 1
    return columns


def num2str(num, format='%s'):
    if int(num) == -1:
        return '?'
    elif int(num) == -2:
        return 'oo'
    else:
        if num > 999:
            return (re.sub(r'(\d{3})', '\g<1>,', str(num)[::-1])[::-1]).lstrip(',')
        else:
            return format % num


def debug(data):
    if cmd_args.DEBUG:
        file = open("debug.log", 'a')
        if type(data) == type(str()):
            file.write(data)
        else:
            import pprint
            pp = pprint.PrettyPrinter(indent=4)
            file.write("\n====================\n" + pp.pformat(data) + "\n====================\n\n")
        file.close

def quit(msg='', exitcode=0):
    try:
        curses.endwin()
    except curses.error:
        pass

    # if this is a graceful exit and config file is present
    if not msg and not exitcode:
        save_config(cmd_args.configfile)
    else:
        print >> sys.stderr, msg,
    os._exit(exitcode)


def explode_connection_string(connection):
    host, port, path = \
        config.get('Connection', 'host'), \
        config.getint('Connection', 'port'),  \
        config.get('Connection', 'path')
    username, password = \
        config.get('Connection', 'username'), \
        config.get('Connection', 'password')
    try:
        if connection.count('@') == 1:
            auth, connection = connection.split('@')
            if auth.count(':') == 1:
                username, password = auth.split(':')
        if connection.count(':') == 1:
            host, port = connection.split(':')
            if port.count('/') >= 1:
                port, path = port.split('/', 1)
            port = int(port)
        else:
            host = connection
    except ValueError:
        quit("Wrong connection pattern: %s\n" % connection)
    return host, port, path, username, password

def create_url(host, port, path):
    url = '%s:%d/%s' % (host, port, path)
    url = url.replace('//', '/')   # double-/ doesn't work for some reason
    if config.getboolean('Connection', 'ssl'):
        return 'https://%s' % url
    else:
        return 'http://%s' % url

def read_netrc(file=os.environ['HOME'] + '/.netrc', hostname=None):
    try:
        login = password = ''
        try:
            login, account, password = netrc.netrc(file).authenticators(hostname)
        except TypeError:
            pass
        try:
            netrc.netrc(file).hosts[hostname]
        except KeyError:
            if hostname != 'localhost':
                print "Unknown machine in %s: %s" % (file, hostname)
                if login and password:
                    print "Using default login: %s" % login
                else:
                    exit(CONFIGFILE_ERROR)
    except netrc.NetrcParseError, e:
        quit("Error in %s at line %s: %s\n" % (e.filename, e.lineno, e.msg))
    except IOError, msg:
        quit("Cannot read %s: %s\n" % (file, msg))
    return login, password


# create initial config file
def create_config(option, opt_str, value, parser):
    configfile = parser.values.configfile
    config.read(configfile)
    if parser.values.connection:
        host, port, path, username, password = explode_connection_string(parser.values.connection)
        config.set('Connection', 'host', host)
        config.set('Connection', 'port', str(port))
        config.set('Connection', 'path', path)
        config.set('Connection', 'username', username)
        config.set('Connection', 'password', password)

    # create directory if necessary
    dir = os.path.dirname(configfile)
    if dir != '' and not os.path.isdir(dir):
        try:
            os.makedirs(dir)
        except OSError, msg:
            print msg
            exit(CONFIGFILE_ERROR)

    # write file
    if not save_config(configfile, force=True):
        exit(CONFIGFILE_ERROR)
    print "Wrote config file: %s" % configfile
    exit(0)

def save_config(filepath, force=False):
    if force or os.path.isfile(filepath):
        try:
            config.write(open(filepath, 'w'))
            os.chmod(filepath, 0600)  # config may contain password
            return 1
        except IOError, msg:
            print >> sys.stderr, "Cannot write config file %s:\n%s" % (filepath, msg)
            return 0
    return -1

def parse_sort_str(sort_str):
    sort_orders = []
    for i in sort_str.split(','):
        x = i.split(':')
        if len(x) > 1:
            sort_orders.append( { 'name':x[1], 'reverse':True } )
        else:
            sort_orders.append( { 'name':x[0], 'reverse':False } )
    return sort_orders

def show_version(option, opt_str, value, parser):
    quit("transmission-remote-cli %s  (supports Transmission %s-%s)\n" % \
         (VERSION, TRNSM_VERSION_MIN, TRNSM_VERSION_MAX))


if __name__ == '__main__':
    # command line parameters
    default_config_path = os.environ['HOME'] + '/.config/transmission-remote-cli/settings.cfg'
    parser = OptionParser(usage="%prog [options] [-- transmission-remote options]",
                          description="%%prog %s" % VERSION)
    parser.add_option("-v", "--version", action="callback", callback=show_version,
                      help="Show version number and supported Transmission versions.")
    parser.add_option("-c", "--connect", action="store", dest="connection", default="",
                      help="Point to the server using pattern [username:password@]host[:port]/[path]")
    parser.add_option("-s", "--ssl", action="store_true", dest="ssl", default=False,
                      help="Connect to Transmission using SSL.")
    parser.add_option("-f", "--config", action="store", dest="configfile", default=default_config_path,
                      help="Path to configuration file.")
    parser.add_option("--create-config", action="callback", callback=create_config,
                      help="Create configuration file CONFIGFILE with default values.")
    parser.add_option("-n", "--netrc", action="store_true", dest="use_netrc", default=False,
                      help="Get authentication info from your ~/.netrc file.")
    parser.add_option("--debug", action="store_true", dest="DEBUG", default=False,
                      help="Everything passed to the debug() function will be added to the file debug.log.")
    (cmd_args, transmissionremote_args) = parser.parse_args()


    # read config from config file
    config.read(cmd_args.configfile)

    # command line connection data can override config file
    if cmd_args.connection:
        host, port, path, username, password = explode_connection_string(cmd_args.connection)
        config.set('Connection', 'host', host)
        config.set('Connection', 'port', str(port))
        config.set('Connection', 'path', path)
        config.set('Connection', 'username', username)
        config.set('Connection', 'password', password)
    if cmd_args.use_netrc:
        username, password = read_netrc(hostname=config.get('Connection','host'))
        config.set('Connection', 'username', username)
        config.set('Connection', 'password', password)
    if cmd_args.ssl:
        config.set('Connection', 'ssl', 'True')



    # forward arguments after '--' to transmission-remote
    if transmissionremote_args:
        cmd = ['transmission-remote', '%s:%s' %
               (config.get('Connection', 'host'), config.get('Connection', 'port'))]

        # one argument and it doesn't start with '-' --> treat it like it's a torrent link/url
        if len(transmissionremote_args) == 1 and not transmissionremote_args[0].startswith('-'):
            cmd.extend(['-a', transmissionremote_args[0]])
        else:
            cmd.extend(transmissionremote_args)

        if config.get('Connection', 'username') and config.get('Connection', 'password'):
            cmd_print = cmd
            cmd_print.extend(['--auth', '%s:PASSWORD' % config.get('Connection', 'username')])
            print "EXECUTING:\n%s\nRESPONSE:" % ' '.join(cmd_print)
            cmd.extend(['--auth', '%s:%s' % (config.get('Connection', 'username'), config.get('Connection', 'password'))])
        else:
            print "EXECUTING:\n%s\nRESPONSE:" % ' '.join(cmd)

        try:
            retcode = call(cmd)
        except OSError, msg:
            quit("Could not execute the above command: %s\n" % msg, 128)
        quit('', retcode)


    norm = Normalizer()
    server = Transmission(config.get('Connection', 'host'),
                          config.getint('Connection', 'port'),
                          config.get('Connection', 'path'),
                          config.get('Connection', 'username'),
                          config.get('Connection', 'password'))
    Interface()

