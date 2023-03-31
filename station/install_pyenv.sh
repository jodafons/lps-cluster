#
# Install pyenv
#
curl https://pyenv.run | bash
echo ''
echo '# setup pyenv' >> /etc/bash.bashrc
echo 'export PATH="$HOME/.pyenv/bin:$PATH"' >> /etc/bash.bashrc
echo 'eval "$(pyenv init --path)"' >> /etc/bash.bashrc

