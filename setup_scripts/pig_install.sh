# Download pig
wget https://ftp.heanet.ie/mirrors/www.apache.org/dist/pig/pig-0.17.0/pig-0.17.0.tar.gz
tar -xvzf pig-0.17.0.tar.gz

# Set home
export PIG_HOME=$(pwd)/pig-0.17.0

# Add paths to bashrc
echo '
export PIG_HOME='$PIG_HOME'
export PATH=$PATH:$PIG_HOME/bin
' >> ~/.bashrc