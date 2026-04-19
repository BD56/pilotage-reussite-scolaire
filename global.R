library(shiny)
library(bslib)
library(bsicons)
library(ggplot2)
library(dplyr)
library(tidyr)
library(plotly)
library(DT)
library(shinyWidgets)
library(scales)

# ============================================================
# Chargement et nettoyage
# ============================================================
df_raw <- read.csv("data/StudentPerformanceFactors.csv", stringsAsFactors = FALSE)

# Outlier : 1 valeur a 101 -> cap a 100
df_raw$Exam_Score[df_raw$Exam_Score > 100] <- 100

# Identifier les lignes incompletes (blancs dans 3 colonnes)
df_raw$has_blank <- df_raw$Teacher_Quality == "" |
  df_raw$Parental_Education_Level == "" |
  df_raw$Distance_from_Home == ""

n_incomplete <- sum(df_raw$has_blank)

# Version nettoyee : suppression des lignes incompletes
df_clean <- df_raw[!df_raw$has_blank, ]

# Traduction et ordonnancement des facteurs
order_levels <- function(data) {
  data %>%
    mutate(
      Parental_Involvement = factor(Parental_Involvement,
        levels = c("Low", "Medium", "High"), labels = c("Faible", "Moyen", "\u00c9lev\u00e9")),
      Access_to_Resources = factor(Access_to_Resources,
        levels = c("Low", "Medium", "High"), labels = c("Faible", "Moyen", "\u00c9lev\u00e9")),
      Motivation_Level = factor(Motivation_Level,
        levels = c("Low", "Medium", "High"), labels = c("Faible", "Moyen", "\u00c9lev\u00e9")),
      Family_Income = factor(Family_Income,
        levels = c("Low", "Medium", "High"), labels = c("Faible", "Moyen", "\u00c9lev\u00e9")),
      Teacher_Quality = factor(Teacher_Quality,
        levels = c("Low", "Medium", "High"), labels = c("Faible", "Moyen", "\u00c9lev\u00e9")),
      Peer_Influence = factor(Peer_Influence,
        levels = c("Negative", "Neutral", "Positive"), labels = c("N\u00e9gatif", "Neutre", "Positif")),
      Parental_Education_Level = factor(Parental_Education_Level,
        levels = c("High School", "College", "Postgraduate"), labels = c("Lyc\u00e9e", "Universit\u00e9", "3\u00e8me cycle")),
      Distance_from_Home = factor(Distance_from_Home,
        levels = c("Near", "Moderate", "Far"), labels = c("Proche", "Mod\u00e9r\u00e9e", "\u00c9loign\u00e9e")),
      School_Type = factor(School_Type,
        levels = c("Public", "Private"), labels = c("Public", "Priv\u00e9")),
      Gender = factor(Gender,
        levels = c("Male", "Female"), labels = c("Homme", "Femme")),
      Extracurricular_Activities = factor(Extracurricular_Activities,
        levels = c("No", "Yes"), labels = c("Non", "Oui")),
      Internet_Access = factor(Internet_Access,
        levels = c("No", "Yes"), labels = c("Non", "Oui")),
      Learning_Disabilities = factor(Learning_Disabilities,
        levels = c("No", "Yes"), labels = c("Non", "Oui"))
    )
}

df_raw   <- order_levels(df_raw)
df_clean <- order_levels(df_clean)

# ============================================================
# Palette de couleurs
# ============================================================
pal <- list(
  primary   = "#4361EE",
  secondary = "#7209B7",
  success   = "#06D6A0",
  warning   = "#FFD166",
  danger    = "#EF476F",
  info      = "#118AB2",
  dark      = "#2C3E50",
  light     = "#F8F9FA",
  bleu1     = "#4361EE",
  bleu2     = "#3A86FF",
  bleu3     = "#8ECAE6",
  violet    = "#7209B7",
  vert      = "#06D6A0",
  orange    = "#FB8500",
  rose      = "#EF476F",
  jaune     = "#FFD166",
  gris      = "#ADB5BD",
  # Palettes ordonnees
  ord3 = c("#EF476F", "#FFD166", "#06D6A0"),   # Low -> High (rouge, jaune, vert)
  cat2 = c("#4361EE", "#FB8500"),               # 2 categories
  cat3 = c("#4361EE", "#7209B7", "#06D6A0"),    # 3 categories
  # Gradients KPI
  kpi_gradients = c(
    "linear-gradient(135deg, #4361EE, #3A86FF)",
    "linear-gradient(135deg, #06D6A0, #00C9A7)",
    "linear-gradient(135deg, #EF476F, #F77F9F)",
    "linear-gradient(135deg, #118AB2, #06D6A0)",
    "linear-gradient(135deg, #7209B7, #9D4EDD)",
    "linear-gradient(135deg, #FB8500, #FFD166)"
  )
)

# ============================================================
# Theme ggplot custom
# ============================================================
theme_dashboard <- function() {
  theme_minimal(base_size = 12, base_family = "") +
    theme(
      plot.background   = element_rect(fill = "transparent", color = NA),
      panel.background  = element_rect(fill = "transparent", color = NA),
      panel.grid.major  = element_line(color = "#E9ECEF", linewidth = 0.3),
      panel.grid.minor  = element_blank(),
      plot.title        = element_text(face = "bold", size = 13, color = "#2C3E50"),
      axis.title        = element_text(size = 10, color = "#5D6D7E"),
      axis.text         = element_text(size = 9, color = "#7F8C8D"),
      legend.background = element_rect(fill = "transparent"),
      legend.text       = element_text(size = 9, color = "#5D6D7E"),
      legend.title      = element_text(size = 10, color = "#2C3E50", face = "bold")
    )
}

# ============================================================
# Helper plotly
# ============================================================
clean_plotly <- function(p) {
  p %>%
    config(displayModeBar = FALSE) %>%
    layout(
      plot_bgcolor  = "transparent",
      paper_bgcolor = "transparent",
      font   = list(family = "Inter, sans-serif", color = "#2C3E50"),
      margin = list(t = 30, b = 50, l = 55, r = 20)
    )
}

# ============================================================
# Variables disponibles
# ============================================================
vars_num <- c("Hours_Studied", "Attendance", "Previous_Scores",
              "Tutoring_Sessions", "Sleep_Hours", "Physical_Activity", "Exam_Score")

vars_cat <- c("Gender", "School_Type", "Family_Income", "Parental_Involvement",
              "Motivation_Level", "Teacher_Quality", "Peer_Influence",
              "Access_to_Resources", "Internet_Access", "Extracurricular_Activities",
              "Learning_Disabilities", "Parental_Education_Level", "Distance_from_Home")

# Labels fran\u00e7ais
labels_fr <- c(
  Hours_Studied              = "Heures d'\u00e9tude",
  Attendance                 = "Assiduit\u00e9 (%)",
  Previous_Scores            = "Scores pr\u00e9c\u00e9dents",
  Tutoring_Sessions          = "Sessions de tutorat",
  Sleep_Hours                = "Heures de sommeil",
  Physical_Activity          = "Activit\u00e9 physique (h/sem)",
  Exam_Score                 = "Score aux examens",
  Gender                     = "Genre",
  School_Type                = "Type d'\u00e9cole",
  Family_Income              = "Revenu familial",
  Parental_Involvement       = "Implication parentale",
  Motivation_Level           = "Motivation",
  Teacher_Quality            = "Qualit\u00e9 enseignant",
  Peer_Influence             = "Influence des pairs",
  Access_to_Resources        = "Acc\u00e8s aux ressources",
  Internet_Access            = "Acc\u00e8s internet",
  Extracurricular_Activities = "Activit\u00e9s extrascolaires",
  Learning_Disabilities      = "Troubles d'apprentissage",
  Parental_Education_Level   = "\u00c9ducation parentale",
  Distance_from_Home         = "Distance domicile-\u00e9cole"
)

# ============================================================
# KPI helper
# ============================================================
make_kpi <- function(value, label, icon_name, gradient, info_text = NULL) {
  info_btn <- NULL
  if (!is.null(info_text)) {
    info_btn <- tooltip(
      bs_icon("question-circle", class = "kpi-info-icon"),
      info_text,
      placement = "bottom"
    )
  }
  div(
    class = "kpi-card",
    style = paste0("background: ", gradient, ";"),
    div(class = "kpi-icon", icon(icon_name)),
    div(class = "kpi-value", value),
    div(class = "kpi-label", label, info_btn)
  )
}

# ============================================================
# Eta carre (part de variance expliquee)
# ============================================================
calc_eta2 <- function(x, y) {
  valid <- !is.na(x) & x != "" & !is.na(y)
  x <- x[valid]; y <- y[valid]
  groups <- split(y, x)
  gm <- mean(y)
  ss_b <- sum(sapply(groups, function(g) length(g) * (mean(g) - gm)^2))
  ss_t <- sum((y - gm)^2)
  if (ss_t == 0) return(0)
  ss_b / ss_t
}

# ============================================================
# Expand card helper (card avec bouton agrandir)
# ============================================================
expand_card <- function(title, plot_id, ..., help_text = NULL, badge_text = NULL, insight = NULL) {
  # "?" -> tooltip (hover)
  help_btn <- NULL
  if (!is.null(help_text)) {
    help_btn <- tooltip(
      bs_icon("question-circle", class = "chart-help-icon"),
      help_text,
      placement = "top"
    )
  }
  # Badge d'effet
  badge <- NULL
  if (!is.null(badge_text)) {
    badge <- span(class = "effect-badge", badge_text)
  }
  # Ampoule -> tooltip (hover) comme le "?"
  insight_btn <- NULL
  if (!is.null(insight)) {
    insight_btn <- tooltip(
      span(class = "chart-insight-icon", icon("lightbulb")),
      paste0("Interpr\u00e9tation possible : ", insight),
      placement = "bottom"
    )
  }
  card(
    class = "chart-card",
    card_header(
      class = "chart-card-header",
      span(title, help_btn, insight_btn, badge),
      actionLink(
        paste0("expand_", plot_id),
        label = NULL,
        icon = icon("expand"),
        class = "expand-btn"
      )
    ),
    card_body(
      ...
    )
  )
}

# ============================================================
# Types de graphiques pour exploration
# ============================================================
trouver_types <- function(var_x, var_y) {
  x_num <- var_x %in% vars_num
  y_num <- !is.null(var_y) && var_y != "" && var_y %in% vars_num
  y_vide <- is.null(var_y) || var_y == ""

  if (x_num && y_vide) return(c("Histogramme", "Boxplot"))
  if (x_num && y_num)  return(c("Nuage de points"))
  if (!x_num && y_vide) return(c("Bar chart", "Camembert"))
  if (!x_num && y_num)  return(c("Boxplot"))
  return(c("Bar chart"))
}
