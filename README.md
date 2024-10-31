# DSIA4101C
**Projet de cours - Filière Data Science :**  
Ce projet, réalisé en binôme, porte sur l'analyse des voies ferroviaires en France. Contrairement au projet DSIA4101A qui est codé en python, ce projet utilise le language R. 

# Jeu de données 

Pour la réalisation de ce projet, nous avons utilisé différentes données issues de la SNCF, soigneusement triées par Mathias Maestri, que nous tenons à remercier chaleureusement. Ces données ont ensuite été exportées dans un fichier au format .geojson.

[Jeu de données utilisé : Données réseau ferroviaire national concaténées](https://www.data.gouv.fr/fr/datasets/donnees-reseau-ferroviaire-national-concatenees/)

[données SNCF](https://data.sncf.com/pages/accueil/)

# Sommaire
## Guide de l'application
1. [Prérequis d'installation](#1---Prérequis-dinstallation)
2. [Lancer l'application sous Rstudio](#2---Lancer-lapplication-sous-Rstudio)
3. [Présentation du Dashboard](#3---Présentation-du-dashboard)

## Analyse des données
1. [Contexte](#1---Contexte)
2. [Analyse des voies ferroviaires françaises](#2---Analyse-des-voies-ferroviaires-françaises)

## Guide du developpeur
1. [Contexte](#1---Contexte)
2. [Architecture du code](#2---Architecture-du-code)
3. [Ajouter une page](#2---Ajouter-une-page)
---

# Guide de l'application

## 1 - Prérequis d'installation

Cette section décrit les étapes nécessaires à l'installation des outils et dépendances pour exécuter l'application.

#### Installation de R
Installez une version récente de R (4.3.0 ou supérieure recommandée) : [Installation de R](https://cran.r-project.org/).

#### Installation de RStudio (optionnel mais recommandé)
Pour un IDE optimisé, installez RStudio : [Installation de RStudio](https://posit.co/download/rstudio-desktop/).

#### Installation des packages R requis
Les packages nécessaires sont listés dans `requirements.R`. Installez-les en exécutant :

```r
source("requirements_R.txt")
```

### Installation de Python 3 (optionnel)

Python est necéssaire si vous souhaitez lancer le script python `create_csv.py` pour obtenir un csv à jour des données. Pour installer une version récente de Python 3 (la version 3.12.0 est recommandée pour ce projet). Vous pouvez télécharger Python à partir du lien suivant :  
[Installation de Python](https://www.python.org/downloads/)

### Installation des packages requis Python (optionnel)

Les dépendances du projet sont listées dans le fichier `requirements.txt`. Pour installer ces packages, ouvrez un terminal et exécutez la commande suivante :  
```
pip install -r requirements_Python.txt
```

### Installation de Git

Pour cloner le dépôt Git de ce projet, assurez-vous que Git est installé sur votre machine. Si ce n'est pas le cas, vous pouvez l'installer à partir de ce lien :  
[Installation de Git](https://git-scm.com/)

### Cloner le dépôt Git

Une fois Git installé, ouvrez `Git Bash` ou tout autre terminal et exécutez la commande suivante pour cloner le projet dans le répertoire de votre choix :  
```
   *git clone https://github.com/Brauxo/DSIA4101C*
```

## 2 - Lancer l'application

Après avoir suivi les étapes d'installation, vous pouvez démarrer l'application en exécutant le fichier `app.R` dans l'IDE R de votre choix (Rstudio dans notre cas)
```
Rscript app.R
```

Si tout se passe comme prévu, Vous allez obtenir une nouvelle fenêtre avec l'application
Normalement l'application est en cours d'exécution en local (localhost) à l'adresse indiquée.

## 3 - Présentation du Dashboard

*(Section à compléter)*

Cette section présentera le fonctionnement du Dashboard une fois lancé, ainsi que ses différentes fonctionnalités.

### Navigation dans le Dashboard


### Page d'accueil 



### Page de la carte 


### Page des graphiques 



### Page d'information sur nous et ce projet



# Analyse des données


## 1 - Contexte

*(Section à compléter)*

Cette section fournira un aperçu général du projet, de ses objectifs ainsi que du contexte de l'analyse sur les voies ferroviaires en France.

## 2 - Analyse des voies ferroviaires françaises

*(Section à compléter)*

#### Analyse Ligne à grande vitesse (LGV)


##### Complément d'analyse


---
# Guide du développeur

## 1 - Contexte

Ce guide développeur présente les objectifs, l'architecture, et la structure de notre projet. Il est conçu pour faciliter l’ajout de nouvelles fonctionnalités et assurer la maintenabilité du code.

Pour garantir la compréhension du code par le plus grand nombre, nous avons choisi de coder en anglais et de respecter les conventions **PEP-8** pour assurer une lisibilité et une cohérence optimales.

Ce guide ne s'attarde pas sur une compréhension exhaustive des codes. Nous expliquons nos choix de conception, les raisons de ces choix, ainsi que la structure logique qui encadre le projet.

## 2 - Architecture du code


## 3 - Ajouter une page



## 4 - Suggestions d'améliorations futures

- Compléter les sections incomplètes (présentation du dashboard, contexte, analyse).
- Ajouter une description détaillée de l'interface du dashboard.
- Inclure des captures d'écran du dashboard dans la section correspondante.
- Décrire l'arborescence des fichiers de manière plus détaillée.
