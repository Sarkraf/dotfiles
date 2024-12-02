This repository is used by [Le Wagon](https://www.lewagon.com) students.

## Toolset

- [oh-my-zsh](http://ohmyz.sh/)
- [Visual Studio Code](https://code.visualstudio.com/)
- [git](https://git-scm.com/)

## Personalization

# ZSH plugins

- [Zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions)
1. Clone the plugin repository in the plugins folder of Zsh
```sh
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
```
2. Add the plugin in the .zshrc file
```sh
plugins=(... zsh-autosuggestions)
```
3. Save and restart zsh

- [Zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting.git)
1. Clone the plugin repository in the plugins folder of Zsh
```sh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```
2. Add the plugin in the .zshrc file
```sh
plugins=(... zsh-autosuggestions zsh-syntax-highlighting)
```
3. Save and restart zsh

- [You-should-use](https://github.com/MichaelAquilina/zsh-you-should-use.git)
1. Clone the plugin repository in the plugins folder of Zsh
```sh
git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
```
2. Add the plugin in the .zshrc file
```sh
plugins=(... zsh-autosuggestions zsh-syntax-highlighting you-should-use)
```
3. Save and restart zsh
