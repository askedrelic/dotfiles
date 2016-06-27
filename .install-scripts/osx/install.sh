

# Ask for the administrator password upfront
sudo -v

# Set my screensaver
defaults -currentHost write com.apple.screensaver 'CleanExit' -string "YES"
defaults -currentHost write com.apple.screensaver 'PrefsVersion' -int "100"
defaults -currentHost write com.apple.screensaver 'idleTime' -int "600"
defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "moduleName" -string "Aerial"
defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "path" -string ~/Library/Screen\ Savers/Aerial.saver
defaults -currentHost write com.apple.screensaver "moduleDict" -dict-add "type" -int "0"
defaults -currentHost write com.apple.screensaver 'ShowClock' -bool "true"
defaults -currentHost write com.apple.screensaver 'tokenRemovalAction' -int "0"

# Always show scrollbars
defaults write -g AppleShowScrollBars -string "Always"
# Jump to the spot that is clicked
defaults write -g AppleScrollerPagingBehavior -int "1"
# Use Dark Interface
defaults write -g AppleInterfaceStyle -string "Dark"

# To reset screensaver
killall cfprefsd
killall SystemUIServer
