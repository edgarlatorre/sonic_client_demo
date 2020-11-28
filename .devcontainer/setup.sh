sh -c "$(wget -O- https://github.com/deluan/zsh-in-docker/releases/download/v1.0.2/zsh-in-docker.sh)"
cp -R /root/.oh-my-zsh /home/$USERNAME
cp /root/.zshrc /home/$USERNAME
sed -i -e "s/\/root\/.oh-my-zsh/\/home\/$USERNAME\/.oh-my-zsh/g" /home/$USERNAME/.zshrc
sed -i -e "s/powerlevel10k\/powerlevel10k/avit/g" /home/$USERNAME/.zshrc

chown -R $USER_UID:$USER_GID /home/$USERNAME/.oh-my-zsh /home/$USERNAME/.zshrc
