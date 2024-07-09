echo "Cleaning up previous build..."

# Delete everything inside the bin folder except the folder itself
rm -r bin/*

echo "Creating .love file..."

# Create a .love file
cp -r . /tmp/conway-breakout > /dev/null
rm -r /tmp/conway-breakout/bin
rm -rf /tmp/conway-breakout/.git
rm -rf /tmp/conway-breakout/.github
rm -rf /tmp/conway-breakout/.vscode
rm -rf /tmp/conway-breakout/assets/src

(cd /tmp/conway-breakout && zip -9 -r ../conway-breakout.love . > /dev/null)

mv /tmp/conway-breakout.love bin

echo "Downloading Love2D for Windows..."

# Download the Love2D binaries (windows32, will run on 64-bit windows as well as linux and macos)
wget -q -P bin https://github.com/love2d/love/releases/download/11.5/love-11.5-win32.zip

echo "Extracting Love2D for Windows..."

# Unzip the love2d binaries
unzip bin/love-11.5-win32.zip -d bin

echo "Building .exe file..."

# Create a .exe file from the .love file
cat bin/love-11.5-win32/love.exe bin/conway-breakout.love > bin/love-11.5-win32/game.exe

echo "Customizing..."

# Rename and remove objects
mv bin/love-11.5-win32 bin/conway-breakout
rm bin/love-11.5-win32.zip
rm bin/conway-breakout/love.exe
rm bin/conway-breakout/lovec.exe

# Change the icons, etc in the future

echo "Zipping..."

# Zip the game
(cd bin && zip -r conway-breakout-windows-x86_64.zip conway-breakout > /dev/null)
rm -r bin/conway-breakout

echo "Finished building for Windows!"
echo "Downloading Love2D for MacOS..."

# Download the Love2D binaries (macos)
wget -q -P bin https://github.com/love2d/love/releases/download/11.5/love-11.5-macos.zip

echo "Unzipping..."

# Unzip
mkdir bin/conway-breakout
unzip bin/love-11.5-macos.zip -d bin/conway-breakout
rm bin/love-11.5-macos.zip

echo "Copying files..."

# Copy the love file into the love.app/Contents/Resources folder
cp bin/conway-breakout.love bin/conway-breakout/love.app/Contents/Resources

# TODO: Change the icons, name, in the plist file

# Zip
echo "Zipping..."

# (cd bin && zip -r conway-breakout-macos.zip conway-breakout > /dev/null) # Commented out .zip, file was too big
(cd bin && tar -czvf conway-breakout-macos.tar.gz conway-breakout)
rm -r bin/conway-breakout

echo "Finished building for MacOS!"
echo "Creating Linux version..."

# Zip
cp build_assets/linux_readme.txt bin/readme.txt
# (cd bin && zip -r conway-breakout-linux-x86_64.zip conway-breakout.love readme.txt) # Used tar instead of zip to be more consistent and reduce file size
(cd bin && tar -czvf conway-breakout-linux-x86_64.tar.gz conway-breakout.love readme.txt)
rm bin/conway-breakout.love
rm bin/readme.txt

echo "Cleaning up..."

# Clean up
rm -rf /tmp/conway-breakout

echo "Done! All files are in the bin folder."
