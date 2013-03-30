#!/usr/bin/env python

"""
Simple way to stream all of twitter user's recent tweets to console and then grep it?

Uses bash variables for config. You need a twitter account.

1. Set this in your .bashrc

export TWITTER_CONSUMER_KEY=""
export TWITTER_CONSUMER_SECRET=""
export TWITTER_ACCESS_TOKEN=""
export TWITTER_ACCESS_TOKEN_SECRET=""

2. run this
./twitter-scrape <username>

"""

import os
import sys
import tweepy


def main(settings, username):
    auth = tweepy.OAuthHandler(settings['TWITTER_CONSUMER_KEY'], settings['TWITTER_CONSUMER_SECRET'])
    auth.set_access_token(settings['TWITTER_ACCESS_TOKEN'], settings['TWITTER_ACCESS_TOKEN_SECRET'])
    api = tweepy.API(auth)

    tweets = []
    max_id = None
    while len(tweets) < 3000:
        if min:
            timeline = api.user_timeline(screen_name=username, count=200, max_id=max_id)
        else:
            timeline = api.user_timeline(screen_name=username, count=200)

        max_id = min([x.id for x in timeline]) - 1
        tweets.extend(timeline)

        for tweet in timeline:
            url = u"http://twitter.com/{}/status/{}".format(username, tweet.id_str)
            print u"{:19} {:<34} {}".format(tweet.created_at.strftime("%x %X"), url, tweet.text.replace('\r','').replace('\n',''))

if __name__ == "__main__":
    settings_list = [
        'TWITTER_CONSUMER_KEY',
        'TWITTER_CONSUMER_SECRET',
        'TWITTER_ACCESS_TOKEN',
        'TWITTER_ACCESS_TOKEN_SECRET',
    ]
    settings = {}
    username = ''
    try:
        for key in settings_list:
            settings[key] = os.environ[key]
    except KeyError, e:
        raise SystemExit('{}: missing environment setting: {}'.format(sys.argv[0], e))

    if len(sys.argv) != 2:
        raise SystemExit('Usage: {} <username>'.format(sys.argv[0]))

    username = sys.argv[1]

    main(settings, username)
