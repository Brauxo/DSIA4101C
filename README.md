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
2. [Lancer l'application sous Rstudio](#2---Lancer-lapplication)
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

Cette section présente le fonctionnement du Dashboard une fois que la page a été lancé grâce au fichier **app.R**, ainsi que ses différentes fonctionnalités.


### Navigation dans le Dashboard
Pour naviguer dans le dashboard on utilise le menu sur le côté et on clique sur la catégorie qui nous interesse. 
<div align="center">
  <img src="https://github.com/Brauxo/DSIA4101C/blob/main/www/navbar_R.png"/>
</div>

### Page d'accueil 
Normalement lorsqu'on arrive sur le dashboard, la page d'accueil est la première page montré, celle-ci elle présente vaguement le contenu du dashboard.
<div align="center">
  <img src="https://github.com/Brauxo/DSIA4101C/blob/main/www/home_R.png"/>
</div>

### Page d'information sur nous et ce projet
Cette page contient les informations sur les outils utilisés et sur nous.
<div align="center">
  <img src="https://github.com/Brauxo/DSIA4101C/blob/main/www/aboutus_R.png"/>
</div>

### Page des histogrammes
Cette page permet d'obtenir des informations sous forme d'histogrammes sur les chemins de fer français.

### Page de la carte 
La page qui montre différentes cartes des chemins de fer français (LGV,Toutes,Lignes classiques), cette page utilise les callbacks pour mettre à jour en direct les cartes.

### Page des Pie charts
Cette page permet d'obtenir des informations sous forme de camemberts sur les chemins de fer français.

### Page des distributions
Cette page permet d'obtenir des informations sous forme de scatterplot sur les chemins de fer français.


# Analyse des données

## 1 - Contexte

L'objectif de ce projet est de fournir un aperçu général et en temps réel des statistiques sur les voies ferroviaires en France, ainsi qu'une représentation cartographique des rails français. Cette analyse permettra de visualiser les caractéristiques du réseau ferroviaire, d’identifier des tendances et les données du réseau. Ce projet s'inscrit dans le cadre de la validation de l'unité DSIA4101.

## 2 - Analyse des voies ferroviaires françaises

#### Analyse Ligne à grande vitesse (LGV)

La **première** **carte**  montre l'entièreté des lignes  générées à partir des données de la sncf, ces lignes sont variées et peuvent être actuellement hors-service.

La **deuxième** **carte**  montre les lignes  générées à partir des données qui ne sont pas des lignes à grandes vitesses (<= 250 km/h), ce sont les lignes dites classique.

La **troisème** **carte**  montre les lignes à grande vitesse (LGV) générées à partir des données. Le critère pour qu'une ligne soit considérée comme LGV est une vitesse maximale supérieure à 250 km/h. Cependant, après une vérification rapide, il apparaît que deux lignes LGV manquent sur cette carte.

La **quatrième** **carte** ajoute ces deux lignes manquantes, qui ont été incluses manuellement. L'absence de ces lignes dans la première carte s'explique par des données incomplètes : la vitesse n'est pas renseignée pour ces deux lignes dans les données.

Complément d'analyse : 

En observant les cartes, on remarque que la majorité des lignes LGV partent ou arrivent à Paris, ce qui souligne un certain phénomène **d'enclavement** du **territoire**. Cette concentration des infrastructures autour de Paris pourrait indiquer une centralisation des transports ferroviaires, reliant principalement la capitale aux autres grandes villes, mais créant moins de connexions directes entre les régions.

#### Analyse des graphiques :

Les graphiques sur les voies ferroviaires en France montrent une répartition intéressante des lignes, en fonction de leur vitesse, de leur électrification et de la taille des tronçons.

**Les** **vitesses** 

Pour les lignes à grande vitesse, on observe qu'elles sont bien représentées, avec 17 tronçons qui roulent à 270 et 300 km/h. On trouve aussi 4 tronçons à 320 km/h et un seul qui atteint 350 km/h. Cela montre que, même si la majorité des LGV roulent à des vitesses proches de 300 km/h, il existe quelques lignes qui vont encore plus vite atteignant une vitesse max de 350 km/h.
Pour lignes classiques, la situation est bien différente. La majorité des tronçons sont assez lents, avec 23,7% des lignes classiques circulant à seulement 30 km/h. celle-ci semblent être régionales en observant sur la carte et repésentent de plus petites distances.

**L’électrification** **des** **lignes** 

En termes d’électrification, on remarque que 67,8% des lignes sont alimentées par un système de 25 000 volts, ce qui est principalement destiné aux LGV. 31,3% des tronçons utilisent un système de 1 500 volts, plus couramment utilisé pour les lignes classiques et régionales. Les autres systèmes d’alimentation, bien que présents, représentent une proportion très faible du réseau mais on peut noté des précisions comme des volts continu par 3 ème rail qui après une recherche sur internet représente les lignes avec un rail supplémentaire.

**La** **taille** **des** **segments** 

Enfin, en ce qui concerne la taille des tronçons, la plupart d'entre eux mesurent moins de 125 km (environ 98% d'entre eux), bien que certains tronçons soient plus longs, notamment le plus grand se situant entre 825 et 875 km. Cela montre que le réseau français est en grande majorité composé de lignes assez courtes, adaptées aux trajets régionaux, même si certaines lignes longues sont concentrées sur les grands axes à grande vitesse. Par ailleurs les troncons les plus grands correpondent aux LGV. 

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
