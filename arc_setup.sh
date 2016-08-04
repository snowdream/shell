#!/bin/bash
PHABRICATOR_URL="https://tails.corp.dropbox.com"
EDITOR="gedit"


if ! hash git &> /dev/null || ! hash php &> /dev/null; then
    echo -e " *****\n ***** INSTALLING GIT AND PHP\n *****"

    if hash apt-get &> /dev/null; then
        sudo apt-get install gedit git-core php-cli php-curl
    elif hash port &> /dev/null; then
        sudo port install gedit php-curl
    elif hash fink &> /dev/null; then
        sudo fink install gedit git php-curl
    elif hash yum &> /dev/null; then
        sudo yum install gedit git php-curl
    fi
fi

if [ ! -d ~/.arc_install ]; then
    echo -e " *****\n ***** CLONING THE ARC TOOL\n *****"
    mkdir ~/.arc_install
    git clone git://github.com/facebook/libphutil.git ~/.arc_install/libphutil
    git clone git://github.com/facebook/arcanist.git ~/.arc_install/arcanist
else
    echo -e " *****\n ***** UPDATING ARC\n *****"
    pushd ~/.arc_install/libphutil/ > /dev/null
    git pull
    cd ~/.arc_install/arcanist/
    git pull
    popd > /dev/null
fi

if [ ! -f ~/.arcrc ]; then
    ~/.arc_install/arcanist/bin/arc set-config default ${PHABRICATOR_URL}
    ~/.arc_install/arcanist/bin/arc set-config editor ${EDITOR}
    ~/.arc_install/arcanist/bin/arc install-certificate
fi

if ! hash arc &> /dev/null; then
    echo -e "\n******************************************************\n"
    echo "   Add \"~/.arc_install/arcanist/bin\" to your path"
    echo -e "\n******************************************************"
fi
