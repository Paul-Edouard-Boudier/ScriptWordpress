
#!/bin/bash
#----------------------
# Name : script.sh
# Authors : Cloé Depardon, Etienne Blanc-Coquand
# Utilities : Script that allows you to create and customize a Wordpress.
# Creation date : 05/12/2017
#----------------------

#----------------------
# Variables for test
# dbName=wordpress
# dbUser=root
# dbPwd=0000
# wpUrl=192.168.33.10
# wpTitle=blog
# wpUser=root
# wpPwd=0000
# wpMail=a@a.com
#----------------------

# Functions declaration
#----------------------
# THEMES
#----------------------
function addTheme {
    wp theme install $1
    echo "Thème installé."
}

function deleteTheme {
    wp theme delete $1
    echo "Thème supprimé."
}

function enableTheme {
    wp theme activate $1
    echo "Thème activé."
}

function disableTheme {
    wp theme disable $1
    echo "Thème désactivé."
}

function searchTheme {
    echo "Résultats pour $1"
    wp theme search $1 --per-page=7
}

#----------------------
# PLUGINS
#----------------------
function addPlugin {
    wp plugin install $1
    echo "Plugin installé."
}

function deletePlugin {
    wp plugin delete $1
    echo "Plugin supprimé."
}

function enablePlugin {
    wp plugin activate $1
    echo "Plugin activé."
}

function disablePlugin {
    wp plugin deactivate $1
    echo "Plugin désactivé."
}

function searchPlugin {
    echo "Résultats pour $1"
    wp plugin search $1 --fields=name,version,slug,rating,num_ratings
}

function reset {
 cd /var/www/html
 wp db reset --yes
}
#----------------------
# INSTALLATION
#----------------------
function setup {
    echo "Vérification des paquets requis et installation de ceux manquants"
    sudo apt-get install -Y mysql-server apache2 php7.0 php7.0-mysql libapache2-mod-php7.0
    sudo a2enmod rewrite
    #TODO : Add SQL query to create the database
    cd /var/www/html/
    sudo rm -rf index.html
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    sudo chmod 777 wp-cli.phar
    sudo mv wp-cli.phar /usr/local/bin/wp
    wp core download
    echo "Fin du téléchargement et de l'installation des composants requis..."
    echo "Configuration de Wordpress"
    echo "Connexion à la base de données :"
    echo "Nom de la base de données :"
    read -e dbName
    echo "Utilisateur de la base de données :"
    read -e dbUser
    echo "Mot de passe :"
    read -s dbPwd
    echo "Configuration du site Wordpress"
    echo "Adresse du site :"
    read -e wpUrl
    echo "Nom du site :"
    read -e wpTitle
    echo "Identifiant administrateur :"
    read -e wpUser
    echo "Mot de passe administrateur :"
    read -s wpPwd
    echo "Adresse mail de l'administrateur :"
    read -e wpMail
    wp config create --dbname=$dbName --dbuser=$dbUser --dbpass=$dbPwd
    wp core install --url=$wpUrl --title=$wpTitle --admin_user=$wpUser --admin_password=$wpPwd --admin_email=$wpMail --skip-email
    sudo service apache2 restart
    echo "Votre site $wpTitle a bien été installé."
}

# Main menu
function menu {
    options=("Installation" "Thèmes" "Plugins" "Reset" "Quitter")
    optionsThemes=("Ajouter" "Supprimer" "Activer" "Désactiver" "Rechercher" "Quitter")
    optionsPlugins=("Ajouter" "Supprimer" "Activer" "Désactiver" "Rechercher" "Quitter")
    echo -e "Sélectionnez une action"
    select responseAction in "${options[@]}";do
        case $responseAction in
            Installation ) choiceAction="Installation";break;;
            Thèmes ) choiceAction="Thèmes";break;;
            Plugins ) choiceAction="Plugins";break;;
            Reset ) choiceAction="Reset";break;;
            Quitter ) choiceAction="Quitter";break;;
        esac
    done

    # Quit action
    if [ $choiceAction == "Quitter" ]
    then
        echo "A bientôt"
        exit;
    fi

    if [ $choiceAction == "Reset" ]
    then
        reset
    fi
    # Install action
    if [ $choiceAction == "Installation" ]
    then
        setup
        menu
    fi

    # Themes action
    if [ $choiceAction == "Thèmes" ]
    then
        select responseTheme in "${optionsThemes[@]}";do
            case $responseTheme in
                Ajouter ) choiceTheme="Ajouter";break;; 
                Supprimer ) choiceTheme="Supprimer";break;; 
                Activer ) choiceTheme="Activer";break;; 
                Désactiver ) choiceTheme="Désactiver";break;; 
                Rechercher ) choiceTheme="Rechercher";break;; 
                Quitter ) choiceTheme="Quitter";break;;
            esac
        done

        # Quit action
        if [ $choiceTheme == "Quitter" ]
        then
            echo "A bientôt"
            exit;
        fi

        # Add theme action
        if [ $choiceTheme == "Ajouter" ]
        then
            echo "Le nom du thème à ajouter :"
            echo "se réferer au slug"
            read -e themeName
            addTheme $themeName
            menu
        fi

        # Delete theme action
        if [ $choiceTheme == "Supprimer" ]
        then
            echo "Le nom du thème à supprimer :"
            echo "se réferer au slug"
            read -e themeName
            deleteTheme $themeName
            menu
        fi

        # Enable theme action
        if [ $choiceTheme == "Activer" ]
        then
            echo "Le nom du thème à supprimer :"
            echo "se réferer au slug"
            read -e themeName
            enableTheme $themeName
            menu
        fi

        # Disable theme action
        if [ $choiceTheme == "Désactiver" ]
        then
            echo "Le nom du thème à supprimer :"
            echo "se réferer au slug"
            read -e themeName
            disableTheme $themeName
            menu
        fi

        # Search theme action
        if [ $choiceTheme == "Rechercher" ]
        then
            echo "Le nom du thème à rechercher :"
            read -e themeName
            searchTheme $themeName
            menu
        fi
    fi

    #Plugins action
    if [ $choiceAction == "Plugins" ]
    then
        select responsPlugins in "${optionsPlugins[@]}";do
            case $responsPlugins in
                Ajouter ) choicePlugin="Ajouter";break;; 
                Supprimer ) choicePlugin="Supprimer";break;; 
                Activer ) choicePlugin="Activer";break;; 
                Désactiver ) choicePlugin="Désactiver";break;; 
                Rechercher ) choicePlugin="Rechercher";break;; 
                Quitter ) choicePlugin="Quitter";break;;
            esac
        done

        # Qui action
        if [ $choicePlugin == "Quitter" ]
        then
            echo "A bientôt"
            exit;
        fi

        # Add plugin action
        if [ $choicePlugin == "Ajouter" ]
        then
            echo "Le nom du plugin à ajouter :"
            read -e pluginName
            addPlugin $pluginName
            menu
        fi

        # Delete plugin action
        if [ $choicePlugin == "Supprimer" ]
        then
            echo "Le nom du thème à supprimer :"
            read -e pluginName
            deletePlugin $pluginName
            menu
        fi

        # Enable plugin action
        if [ $choicePlugin == "Activer" ]
        then
            echo "Le nom du thème à supprimer :"
            read -e pluginName
            enablePlugin $pluginName
            menu
        fi

        # Disable plugin action
        if [ $choicePlugin == "Désactiver" ]
        then
            echo "Le nom du plugin à supprimer :"
            read pluginName
            disablePlugin $pluginName
            menu
        fi

        # Search plugin action
        if [ $choicePlugin == "Rechercher" ]
        then
            echo "Le nom du plugin à rechercher :"
            read -e pluginName
            searchPlugin $pluginName
            menu
        fi
        
    fi
}

menu
