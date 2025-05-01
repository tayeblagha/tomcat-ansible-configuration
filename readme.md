# Configuration DevOpsTest

## 🎥 Démo vidéo  
[Voir la démonstration vidéo](https://drive.google.com/file/d/1HWZYXceaLYLhyQ2ZrTyL-xhtl1WphEXY/view?usp=drive_link)

---

## 📝 Notes importantes  
- **Image Docker**  
  Debian Jessie n’étant plus supportée, l’image a été remplacée par `debian:bullseye-slim`.  
- **Playbook Ansible**  
  Dans `tomcat_test.sh`, le chemin du playbook a été modifié de `/data/deploy.yml` vers `/data/tomcat_deploy.yml`, conformément à l’exercice “Produire un playbook Ansible « tomcat_deploy.yml »”.  
- **Lien symbolique des logs**  
  Le chemin par défaut `/var/log/tomcat/catalina.out` a été redirigé vers `/var/log/tomcat9/catalina.out` via un lien symbolique.

---

## 📁 Arborescence du projet  

```
DevOpsTest/
├── deploy/
│   ├── tomcat_deploy.yml
│   └── sample.war (provided)
├── prod/
│   ├── Dockerfile
│   └── tomcat_test.sh
└── tomcat_deploy.sh
```


---

## 🚀 Description des principaux fichiers

### 1. Dockerfile (`prod/Dockerfile`)
- **Base** : `FROM debian:bullseye-slim`  
- **Installation** :  
  - Ansible, Java 11 (OpenJDK), `systemd`, utilitaires réseau, etc.  
  - Nettoyage des caches APT pour alléger l’image.  
- **Configuration** :  
  - Création des dossiers Ansible et de l’inventaire local (`/etc/ansible/hosts`).  
  - Copie et permission du script de test `tomcat_test.sh`.  
- **Lancement** :  
  - Démarrage de `systemd` en tant que processus PID 1 pour permettre l’exécution du playbook.

### 2. Playbook Ansible (`deploy/tomcat_deploy.yml`)
- **Objectif** : Installer et configurer Tomcat 9 avec variables paramétrables (`tomcat_version`, `install_dir`, `env`, etc.).
- **Étapes clés** :  
  1. Installation de Java (OpenJDK 11).  
  2. Création de l’utilisateur et du groupe `tomcat`.  
  3. Téléchargement et extraction de Tomcat depuis les archives Apache.  
  4. Définition des droits et configuration des variables d’environnement (`CATALINA_HOME`, `JAVA_HOME`).  
  5. Génération d’un script `setenv.sh` ajustant la taille du heap JVM selon l’environnement (`DEV`/`PROD`).  
  6. Déploiement d’un `sample.war` pour validation.  
  7. Création du répertoire de logs `/var/log/tomcat9` et mise en place d’un lien symbolique vers `catalina.out`.  
  8. Création et activation d’un service `systemd` pour Tomcat.  
  9. Pause conditionnelle pour laisser le temps au service de démarrer (10 s en DEV, 15 s en PROD).

### 3. Script de build et test (`tomcat_deploy.sh`)
- **Usage** : `./tomcat_deploy.sh <ENVIRONMENT>` (`DEV` par défaut si non `PROD`).  
- **Fonctions** :  
  1. Suppression du conteneur existant (`docker rm -f`).  
  2. Construction de l’image Docker (`docker build -t tayeblagha/tomcatdeployment ./prod`).  
  3. Lancement du conteneur en mode privilégié, montage du dossier `deploy` en volume.  
  4. Pause pour initialisation de `systemd` (7 secondes).  
  5. Exécution du script de test `tomcat_test.sh` dans le conteneur avec l’environnement choisi.

---
