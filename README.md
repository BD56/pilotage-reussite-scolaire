# Pilotage de la Reussite Scolaire

Tableau de bord decisionnel (Business Intelligence) realise dans le cadre d'un projet universitaire.

**Scenario** : tableau de bord a destination du Rectorat de l'Academie de Rennes, visant a identifier les facteurs influencant la performance scolaire des eleves afin d'orienter les politiques d'accompagnement et d'allocation des ressources.

**Dashboard en ligne** : https://desjardins-bryan.shinyapps.io/pilotage-reussite/

---

## Stack technique

- **R** 4.5+
- **Shiny** + **bslib** (Bootstrap 5)
- **plotly** pour les graphiques interactifs
- **ggplot2**, **dplyr**, **DT**

## Structure du projet

```
dataviz/
├── global.R       # chargement donnees, palette, helpers
├── ui.R           # interface utilisateur (CSS custom, 7 onglets)
├── server.R       # logique reactive, graphiques, KPIs
├── data/
│   └── StudentPerformanceFactors.csv
├── rapport/
│   └── rapport_BI.pdf
├── CONTEXTE.md
└── dataviz.Rproj
```

## Donnees

**Source** : [Student Performance Factors](https://www.kaggle.com/datasets/ayeshasiddiqa123/student-perfirmance) (Kaggle, licence CC0)
**Volume** : 6 607 observations, 20 variables

## Lancer l'application localement

```r
# Installer les dependances
install.packages(c("shiny", "bslib", "bsicons", "ggplot2", "dplyr",
                   "tidyr", "plotly", "DT", "shinyWidgets", "scales"))

# Lancer depuis le dossier du projet
shiny::runApp()
```

## Auteurs

Desjardins Bryan & Festoc Julianne
