# Docker Ubuntu Emacs

Ubuntu image with Emacs installed.

# Requirements

* Host must be running Xserver.
  * For MacOS
    * Install `XQuartz`
      ``` bash
      brew install --cask xquartz
      ```
    * Launch `XQuartz`. Select `Preferences >> Security`, check "Allow connections from network clients".
    * Allow network `X11` connections from `localhost`.
      ``` bash
      xhost +localhost
      ```

# Scripts

* `build-image`
