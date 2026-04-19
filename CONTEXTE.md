# Pilotage de la Reussite Scolaire — Contexte du projet

## Cadre reel

**Formation** : Master 1 — Semestre 2
**Cours** : Business Intelligence / Data Visualisation
**Annee** : 2025-2026
**Equipe** : Desjardins Bryan, Festoc Julianne

**Consigne** :
1. Construire un projet d'entreprise autour de donnees open source. Rediger un rapport PDF (3 pages max) specifiant : entreprise, taille, portee, environnement, business model, scenario BI, business process, perspectives, roles, instances, vues, objectifs d'analyse BI, KPIs, facteurs influents, objectifs analytiques, sources de donnees.
2. Realiser un tableau de bord interactif repondant aux objectifs d'analyse BI.

**Outils** : R, Shiny (bslib), ggplot2, plotly
**Donnees** : Student Performance Factors — Kaggle (CC0, domaine public) — 6 607 observations, 20 variables
**Lien donnees** : https://www.kaggle.com/datasets/ayeshasiddiqa123/student-perfirmance
**Dashboard en ligne** : https://desjardins-bryan.shinyapps.io/pilotage-reussite/

---

## Scenario fictif

**Organisation** : Rectorat de l'Academie de Rennes
**Perimetre** : 4 departements bretons (Cotes-d'Armor, Finistere, Ille-et-Vilaine, Morbihan)
**Portee** : Regionale — Bretagne
**Financement** : Service public — Ministere de l'Education Nationale et Region Bretagne

**Contexte** : L'Academie de Rennes evolue dans un environnement marque par une forte mixite entre etablissements publics et prives, des enjeux de ruralite et des disparites socio-economiques entre territoires. La lutte contre le decrochage scolaire et la reduction des inegalites sont au coeur des priorites nationales.

**Objectif BI** : Deployer un tableau de bord decisionnel pour analyser les facteurs influencant la reussite scolaire des eleves de l'academie. L'enjeu est de mieux cibler les dispositifs d'accompagnement (tutorat, ressources, soutien parental) en identifiant les profils d'eleves les plus a risque d'echec.

**Processus metier** : Pilotage de la reussite scolaire — collecte des donnees, analyse des performances, identification des facteurs d'echec, allocation des moyens, suivi de l'impact.

**Utilisateurs cibles** :
- Recteur / Directeur academique — vision strategique, arbitrages
- Inspecteur d'academie — diagnostic des inegalites, plans d'action
- Chef d'etablissement — exploitation locale, leviers d'action
- Service Statistique Academique — alimentation et fiabilisation des donnees

---

## Ce que le dashboard apporte

**Constats cles issus de l'analyse** :
- L'assiduite est le facteur le plus fortement associe au score (31.2% de la variance expliquee)
- Les heures d'etude constituent le deuxieme facteur (15.3%)
- Les facteurs socio-economiques (revenu, education parentale) montrent des ecarts faibles (1 a 2 points)
- Le type d'ecole (public vs prive) et le genre ne montrent pas de difference notable dans ces donnees

**Limites assumees** :
- Les donnees ne proviennent pas de l'Academie de Rennes — le scenario est fictif
- La variance des scores est faible (ecart-type ~3.9)
- Les correlations ne permettent pas d'etablir des liens de causalite
- Les interpretations sont des pistes de reflexion, pas des conclusions definitives
