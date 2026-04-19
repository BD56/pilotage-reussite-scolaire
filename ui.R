page_navbar(
  title = span(
    icon("graduation-cap", style = "margin-right: 8px;"),
    "Pilotage de la R\u00e9ussite Scolaire"
  ),
  theme = bs_theme(
    version = 5,
    bootswatch = "flatly",
    primary   = "#4361EE",
    secondary = "#7209B7",
    success   = "#06D6A0",
    info      = "#118AB2",
    warning   = "#FFD166",
    danger    = "#EF476F",
    base_font = font_google("Inter"),
    heading_font = font_google("Inter"),
    font_scale = 0.9,
    "navbar-bg" = "#FFFFFF"
  ),
  fillable = FALSE,
  id = "main_nav",

  # ============================================================
  # CSS CUSTOM
  # ============================================================
  header = tags$head(
    tags$script(HTML("
      $(document).on('shiny:connected', function() {
        function checkKpiOverflow() {
          var container = document.querySelector('.kpi-scroll-container');
          var wrapper = document.querySelector('.kpi-scroll-wrapper');
          if (container && wrapper) {
            if (container.scrollWidth > container.clientWidth) {
              wrapper.classList.add('has-overflow');
            } else {
              wrapper.classList.remove('has-overflow');
            }
          }
        }
        setTimeout(checkKpiOverflow, 500);
        window.addEventListener('resize', checkKpiOverflow);
        // Hide fade when scrolled to end
        var container = document.querySelector('.kpi-scroll-container');
        if (container) {
          container.addEventListener('scroll', function() {
            var wrapper = document.querySelector('.kpi-scroll-wrapper');
            if (this.scrollLeft + this.clientWidth >= this.scrollWidth - 10) {
              wrapper.classList.remove('has-overflow');
            } else if (this.scrollWidth > this.clientWidth) {
              wrapper.classList.add('has-overflow');
            }
          });
        }
      });
    ")),
    tags$style(HTML("
      /* ---- Base ---- */
      body { background: #F0F2F5 !important; }

      /* ---- Navbar ---- */
      .navbar {
        background: white !important;
        box-shadow: 0 1px 8px rgba(0,0,0,0.06) !important;
        padding: 8px 24px !important;
      }
      .navbar-brand {
        font-weight: 700 !important;
        color: #2C3E50 !important;
        font-size: 1.05rem !important;
      }
      .navbar-nav {
        background: #F0F2F5;
        padding: 4px;
        border-radius: 10px;
        gap: 4px !important;
      }
      .navbar-nav .nav-link {
        color: #7F8C8D !important;
        font-weight: 500 !important;
        border-radius: 8px !important;
        padding: 6px 14px !important;
        font-size: 0.85rem !important;
        transition: all 0.2s ease !important;
      }
      .navbar-nav .nav-link:hover {
        color: #4361EE !important;
        background: rgba(67, 97, 238, 0.08) !important;
      }
      .navbar-nav .nav-link.active {
        background: #4361EE !important;
        color: white !important;
        box-shadow: 0 2px 8px rgba(67, 97, 238, 0.3);
      }

      /* ---- Sidebar ---- */
      .bslib-sidebar-layout > .sidebar {
        background: white !important;
        border-right: 1px solid #E9ECEF !important;
        box-shadow: 1px 0 8px rgba(0,0,0,0.04) !important;
      }
      .sidebar .sidebar-title {
        font-weight: 700 !important;
        color: #2C3E50 !important;
      }
      details.sidebar-section {
        border: 1px solid #E9ECEF;
        border-radius: 10px;
        padding: 0;
        margin-bottom: 10px;
        overflow: visible;
        transition: all 0.2s ease;
      }
      details.sidebar-section:hover {
        border-color: #4361EE;
      }
      details.sidebar-section summary {
        padding: 10px 14px;
        font-weight: 600;
        font-size: 0.82rem;
        color: #2C3E50;
        cursor: pointer;
        list-style: none;
        display: flex;
        align-items: center;
        gap: 8px;
        background: #FAFBFC;
        border-bottom: 1px solid transparent;
      }
      details[open].sidebar-section summary {
        border-bottom: 1px solid #E9ECEF;
        color: #4361EE;
      }
      details.sidebar-section summary::-webkit-details-marker { display: none; }
      details.sidebar-section summary::before {
        content: '\\25B6';
        font-size: 0.6rem;
        transition: transform 0.2s ease;
        color: #ADB5BD;
      }
      details[open].sidebar-section summary::before {
        transform: rotate(90deg);
        color: #4361EE;
      }
      details.sidebar-section > div {
        padding: 10px 14px;
      }
      .effectif-badge {
        background: linear-gradient(135deg, #4361EE, #3A86FF);
        color: white;
        padding: 8px 16px;
        border-radius: 10px;
        text-align: center;
        font-weight: 600;
        font-size: 0.82rem;
        margin-top: 10px;
        box-shadow: 0 2px 8px rgba(67, 97, 238, 0.25);
      }

      /* ---- Cards ---- */
      .card {
        border: none !important;
        border-radius: 12px !important;
        box-shadow: 0 2px 12px rgba(0,0,0,0.06) !important;
        transition: all 0.25s ease !important;
        overflow: visible !important;
      }
      .card:hover {
        box-shadow: 0 4px 20px rgba(0,0,0,0.10) !important;
      }
      .chart-card-header {
        display: flex !important;
        justify-content: space-between !important;
        align-items: center !important;
        font-weight: 600 !important;
        font-size: 0.88rem !important;
        color: #2C3E50 !important;
        padding: 14px 20px !important;
        background: white !important;
        border-bottom: 1px solid #F0F2F5 !important;
      }
      .expand-btn {
        color: #ADB5BD !important;
        font-size: 0.85rem;
        padding: 4px 8px;
        border-radius: 6px;
        transition: all 0.2s ease;
      }
      .expand-btn:hover {
        color: #4361EE !important;
        background: rgba(67, 97, 238, 0.08);
      }

      /* ---- KPI Cards ---- */
      .kpi-card {
        border-radius: 12px;
        padding: 20px;
        text-align: center;
        color: white;
        box-shadow: 0 3px 15px rgba(0,0,0,0.1);
        transition: transform 0.25s ease, box-shadow 0.25s ease;
        height: 120px;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
      }
      .kpi-card:hover {
        transform: translateY(-3px);
        box-shadow: 0 6px 25px rgba(0,0,0,0.18);
      }
      .kpi-icon { font-size: 1.3rem; margin-bottom: 4px; opacity: 0.85; }
      .kpi-value { font-size: 1.8rem; font-weight: 700; line-height: 1.2; }
      .kpi-label { font-size: 0.72rem; opacity: 0.9; font-weight: 500; margin-top: 2px; }

      /* ---- Select inputs ---- */
      .form-select, .form-control {
        border-radius: 8px !important;
        border: 1px solid #E2E8F0 !important;
        font-size: 0.82rem !important;
        padding: 6px 10px !important;
        transition: border-color 0.2s ease, box-shadow 0.2s ease !important;
      }
      .form-select:focus, .form-control:focus {
        border-color: #4361EE !important;
        box-shadow: 0 0 0 3px rgba(67, 97, 238, 0.1) !important;
      }
      .control-label {
        font-size: 0.78rem !important;
        font-weight: 600 !important;
        color: #5D6D7E !important;
        margin-bottom: 3px !important;
      }

      /* ---- Exploration stats ---- */
      .explo-stats {
        background: #F8F9FA;
        border-left: 4px solid #4361EE;
        padding: 14px 18px;
        border-radius: 0 8px 8px 0;
        margin-top: 10px;
        font-size: 0.82rem;
        color: #2C3E50;
      }
      .explo-stats-title {
        font-weight: 700;
        margin-bottom: 8px;
        color: #4361EE;
        font-size: 0.85rem;
      }
      .stat-badge {
        display: inline-block;
        background: #E8F0FE;
        color: #4361EE;
        font-weight: 600;
        font-size: 0.75rem;
        padding: 3px 10px;
        border-radius: 20px;
        margin: 2px 4px 2px 0;
      }

      /* ---- KPI responsive container ---- */
      .kpi-scroll-container {
        display: flex;
        gap: 12px;
        overflow-x: auto;
        padding: 4px 0 8px 0;
        scroll-snap-type: x mandatory;
        -webkit-overflow-scrolling: touch;
        width: 100%;
      }
      .kpi-scroll-container::-webkit-scrollbar { height: 4px; }
      .kpi-scroll-container::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 10px; }
      .kpi-scroll-container > div {
        flex: 1 0 160px;
        min-width: 160px;
        scroll-snap-align: start;
        display: flex;
      }
      .kpi-scroll-container > div > .kpi-card {
        width: 100%;
      }
      /* Indicateur de scroll (fade droit) */
      .kpi-scroll-wrapper {
        position: relative;
      }
      .kpi-scroll-wrapper::after {
        content: '';
        position: absolute;
        top: 0; right: 0;
        width: 40px;
        height: 100%;
        background: linear-gradient(to left, #F0F2F5, transparent);
        pointer-events: none;
        opacity: 0;
        transition: opacity 0.3s ease;
      }
      .kpi-scroll-wrapper.has-overflow::after {
        opacity: 1;
      }
      /* Desktop : grille 6 colonnes, toute la largeur */
      @media (min-width: 1200px) {
        .kpi-scroll-container {
          overflow-x: visible;
          justify-content: stretch;
        }
        .kpi-scroll-container > div {
          flex: 1 1 0;
          min-width: 0;
        }
        .kpi-scroll-wrapper::after { display: none; }
      }
      /* Tablette : grille 3x2 */
      @media (min-width: 768px) and (max-width: 1199px) {
        .kpi-scroll-container {
          flex-wrap: wrap;
          overflow-x: visible;
        }
        .kpi-scroll-container > div {
          flex: 1 1 calc(33.33% - 8px);
          min-width: calc(33.33% - 8px);
        }
        .kpi-scroll-wrapper::after { display: none; }
      }
      /* Mobile : scroll horizontal */
      @media (max-width: 767px) {
        .kpi-scroll-container > div {
          flex: 0 0 160px;
        }
      }

      /* ---- DT table ---- */
      table.dataTable thead th {
        background: #F8F9FA !important;
        color: #2C3E50 !important;
        font-weight: 600 !important;
        font-size: 0.8rem !important;
        border-bottom: 2px solid #4361EE !important;
      }
      table.dataTable tbody td {
        font-size: 0.8rem !important;
        color: #475569 !important;
      }
      table.dataTable tbody tr:hover {
        background: rgba(67, 97, 238, 0.05) !important;
      }

      /* ---- Scrollbar ---- */
      ::-webkit-scrollbar { width: 6px; height: 6px; }
      ::-webkit-scrollbar-track { background: transparent; }
      ::-webkit-scrollbar-thumb { background: #CBD5E1; border-radius: 10px; }
      ::-webkit-scrollbar-thumb:hover { background: #94A3B8; }

      /* ---- Modal ---- */
      .modal-content { border-radius: 16px !important; border: none !important; }
      .modal-header { border-bottom: 1px solid #F0F2F5 !important; }
      .modal-footer { border-top: 1px solid #F0F2F5 !important; }

      /* ---- Min-height pour assurer la lisibilite des graphiques ---- */
      /* Les plotlyOutput definissent une hauteur nominale ; on s'assure
         que leur container respecte bien cette hauteur + padding */
      .chart-card {
        min-height: 280px;
      }
      /* Card specifique pour le barplot eta2 (19 labels) */
      #barplot_eta2 { min-height: 500px !important; }
      /* Heatmap de correlation */
      #heatmap_cor { min-height: 380px !important; }
      /* Histogramme */
      #hist_scores { min-height: 300px !important; }

      /* ---- Chart help icon ---- */
      .chart-help-icon {
        font-size: 0.75rem;
        color: #ADB5BD;
        margin-left: 6px;
        cursor: pointer;
        vertical-align: middle;
        transition: color 0.2s ease;
      }
      .chart-help-icon:hover { color: #4361EE; }

      /* ---- Effect badge ---- */
      .effect-badge {
        display: inline-block;
        font-size: 0.65rem;
        font-weight: 600;
        padding: 2px 8px;
        border-radius: 20px;
        margin-left: 8px;
        vertical-align: middle;
        background: #EEF2FF;
        color: #4361EE;
      }

      /* ---- Chart insight icon ---- */
      .chart-insight-icon {
        display: inline-flex;
        align-items: center;
        justify-content: center;
        color: #FFD166;
        font-size: 0.85rem;
        cursor: pointer;
        margin-right: 4px;
        width: 22px;
        height: 22px;
        transition: all 0.2s ease;
      }
      .chart-insight-icon:hover {
        color: #FB8500;
        transform: scale(1.15);
      }

      /* ---- KPI info icon ---- */
      .kpi-info-icon {
        font-size: 0.7rem;
        opacity: 0.7;
        margin-left: 4px;
        cursor: pointer;
        vertical-align: middle;
        transition: opacity 0.2s ease;
      }
      .kpi-info-icon:hover { opacity: 1; }
      .popover { border-radius: 10px !important; font-size: 0.8rem !important; }
      .popover-body { color: #475569 !important; line-height: 1.5; }

      /* ---- Slider inputs ---- */
      .irs--shiny .irs-bar { background: #4361EE !important; border-top: 1px solid #4361EE !important; border-bottom: 1px solid #4361EE !important; }
      .irs--shiny .irs-handle { border: 2px solid #4361EE !important; }
      .irs--shiny .irs-from, .irs--shiny .irs-to, .irs--shiny .irs-single { background: #4361EE !important; }

      /* ---- A propos ---- */
      .about-hero {
        background: linear-gradient(135deg, #4361EE, #7209B7);
        border-radius: 16px;
        padding: 40px 36px;
        color: white;
        margin-bottom: 20px;
        position: relative;
        overflow: hidden;
      }
      .about-hero::after {
        content: '';
        position: absolute;
        top: -40px; right: -40px;
        width: 200px; height: 200px;
        background: rgba(255,255,255,0.08);
        border-radius: 50%;
      }
      .about-hero h2 { font-size: 1.5rem; font-weight: 700; margin-bottom: 8px; }
      .about-hero p { font-size: 0.88rem; opacity: 0.9; line-height: 1.6; max-width: 700px; }
      .about-card h4 {
        font-size: 0.85rem;
        font-weight: 700;
        color: #4361EE;
        margin-bottom: 14px;
        display: flex;
        align-items: center;
        gap: 8px;
      }
      .about-icon {
        width: 28px; height: 28px;
        background: #EEF2FF;
        border-radius: 8px;
        display: inline-flex; align-items: center; justify-content: center;
        font-size: 0.8rem;
        color: #4361EE;
      }
      .about-table { width: 100%; border-collapse: collapse; font-size: 0.8rem; }
      .about-table td { padding: 7px 0; border-bottom: 1px solid #F0F2F5; }
      .about-table td:first-child { font-weight: 600; color: #5D6D7E; width: 40%; }
      .about-table td:last-child { color: #2C3E50; }
      .about-role {
        display: flex; align-items: center; gap: 12px;
        padding: 9px 0; border-bottom: 1px solid #F0F2F5;
      }
      .about-role:last-child { border-bottom: none; }
      .about-avatar {
        width: 34px; height: 34px; border-radius: 10px;
        display: flex; align-items: center; justify-content: center;
        font-size: 0.75rem; color: white; font-weight: 600; flex-shrink: 0;
      }
      .about-role-name { font-weight: 600; font-size: 0.8rem; }
      .about-role-desc { font-size: 0.72rem; color: #7F8C8D; }
      .about-badges { display: flex; flex-wrap: wrap; gap: 6px; margin-top: 10px; }
      .about-badge {
        font-size: 0.7rem; font-weight: 600;
        padding: 3px 10px; border-radius: 20px;
      }
      .about-badge.blue { background: #EEF2FF; color: #4361EE; }
      .about-badge.purple { background: #F3E8FF; color: #7209B7; }
      .about-badge.green { background: #ECFDF5; color: #059669; }
      .about-limit {
        display: flex; gap: 8px; padding: 8px 0;
        border-bottom: 1px solid #F0F2F5; font-size: 0.8rem;
      }
      .about-limit:last-child { border-bottom: none; }
      .about-limit-dot { color: #FFD166; flex-shrink: 0; }
      .about-limit-text { color: #5D6D7E; line-height: 1.5; }
      .about-footer {
        text-align: center; padding: 16px;
        font-size: 0.75rem; color: #94A3B8; margin-top: 8px;
      }

      /* ---- A propos cards : pas de scroll interne ---- */
      .about-card .card-body {
        overflow: visible !important;
        max-height: none !important;
      }
      /* Tableau about : largeur auto, pas de width fixe */
      .about-table td { vertical-align: top; }
      .about-table td:first-child {
        white-space: nowrap;
        padding-right: 12px;
        width: auto !important;
      }
      .about-table td:last-child { word-wrap: break-word; }
      /* Responsive : passer en 2 colonnes puis 1 colonne */
      @media (max-width: 1199px) {
        .about-row-3 .bslib-grid {
          grid-template-columns: repeat(2, 1fr) !important;
        }
        .about-row-3 .bslib-grid > div:nth-child(3) {
          grid-column: 1 / -1 !important;
        }
      }
      @media (max-width: 767px) {
        .about-row-3 .bslib-grid,
        .about-row-2 .bslib-grid {
          grid-template-columns: 1fr !important;
        }
        .about-row-3 .bslib-grid > div:nth-child(3) {
          grid-column: auto !important;
        }
        .about-hero { padding: 28px 24px; }
        .about-hero h2 { font-size: 1.25rem; }
      }

      /* ---- Reset button ---- */
      .btn-reset {
        background: #F0F2F5;
        border: 1px solid #E2E8F0;
        color: #7F8C8D;
        font-size: 0.78rem;
        font-weight: 500;
        border-radius: 8px;
        padding: 6px 14px;
        width: 100%;
        transition: all 0.2s ease;
        cursor: pointer;
      }
      .btn-reset:hover {
        background: #EEF2FF;
        border-color: #4361EE;
        color: #4361EE;
      }

      /* ---- Info source ---- */
      .source-info {
        font-size: 0.72rem;
        color: #94A3B8;
        padding: 10px 0;
        border-top: 1px solid #E9ECEF;
        margin-top: 12px;
      }
    "))
  ),

  # ============================================================
  # Sidebar
  # ============================================================
  sidebar = sidebar(
    width = 300,
    open = TRUE,

    tags$div(
      style = "font-weight: 700; font-size: 0.95rem; color: #2C3E50; margin-bottom: 12px;",
      icon("filter", style = "margin-right: 6px; color: #4361EE;"), "Filtres"
    ),

    # Toggle donnees incompletes
    div(style = "display: flex; align-items: center; gap: 4px;",
      materialSwitch(
        inputId = "inclure_na",
        label = span(style = "font-size: 0.78rem; font-weight: 500;", "Inclure individus incomplets"),
        value = FALSE,
        status = "primary",
        right = TRUE
      ),
      tooltip(
        bs_icon("question-circle", class = "chart-help-icon", style = "margin-bottom: 12px;"),
        paste0(
          n_incomplete, " individus ont au moins une valeur manquante sur 3 variables : ",
          "Qualit\u00e9 enseignant (", sum(df_raw$Teacher_Quality == "" | is.na(df_raw$Teacher_Quality)), " manquantes), ",
          "\u00c9ducation parentale (", sum(df_raw$Parental_Education_Level == "" | is.na(df_raw$Parental_Education_Level)), " manquantes), ",
          "Distance domicile (", sum(df_raw$Distance_from_Home == "" | is.na(df_raw$Distance_from_Home)), " manquantes). ",
          "Par d\u00e9faut, ces individus sont exclus pour \u00e9viter les biais dans les analyses impliquant ces variables."
        ),
        placement = "right"
      )
    ),

    # Section Seuils KPI
    tags$details(
      class = "sidebar-section",
      tags$summary(icon("sliders", style = "font-size: 0.75rem;"), "Seuils KPI"),
      tags$div(
        sliderInput("seuil_reussite", "Seuil de r\u00e9ussite",
                    min = 60, max = 80, value = 67, step = 1, width = "100%"),
        sliderInput("seuil_difficulte", "Seuil de difficult\u00e9",
                    min = 55, max = 70, value = 65, step = 1, width = "100%"),
        tags$small(style = "color: #94A3B8; font-size: 0.7rem;",
                   "Les valeurs par d\u00e9faut (67 et 65) sont bas\u00e9es sur la m\u00e9diane et le 1er quartile du jeu de donn\u00e9es.")
      )
    ),

    # Section Profil \u00e9l\u00e8ve
    tags$details(
      class = "sidebar-section", open = NA,
      tags$summary(icon("user", style = "font-size: 0.75rem;"), "Profil \u00e9l\u00e8ve"),
      tags$div(
        selectInput("filtre_genre", "Genre", c("Tous", "Homme", "Femme"), width = "100%"),
        selectInput("filtre_motivation", "Motivation", c("Tous", "Faible", "Moyen", "\u00c9lev\u00e9"), width = "100%"),
        selectInput("filtre_extra", "Activit\u00e9s extra.", c("Tous", "Non", "Oui"), width = "100%"),
        selectInput("filtre_handicap", "Troubles d'apprent.", c("Tous", "Non", "Oui"), width = "100%")
      )
    ),

    # Section Contexte familial
    tags$details(
      class = "sidebar-section",
      tags$summary(icon("house", style = "font-size: 0.75rem;"), "Contexte familial"),
      tags$div(
        selectInput("filtre_income", "Revenu familial", c("Tous", "Faible", "Moyen", "\u00c9lev\u00e9"), width = "100%"),
        selectInput("filtre_parental", "Implication parentale", c("Tous", "Faible", "Moyen", "\u00c9lev\u00e9"), width = "100%"),
        selectInput("filtre_education", "\u00c9ducation parentale",
                    c("Tous", "Lyc\u00e9e", "Universit\u00e9", "3\u00e8me cycle"), width = "100%"),
        selectInput("filtre_internet", "Acc\u00e8s internet", c("Tous", "Oui", "Non"), width = "100%"),
        selectInput("filtre_distance", "Distance domicile",
                    c("Tous", "Proche", "Mod\u00e9r\u00e9e", "\u00c9loign\u00e9e"), width = "100%")
      )
    ),

    # Section \u00c9tablissement
    tags$details(
      class = "sidebar-section",
      tags$summary(icon("building", style = "font-size: 0.75rem;"), "\u00c9tablissement"),
      tags$div(
        selectInput("filtre_school", "Type d'\u00e9cole", c("Tous", "Public", "Priv\u00e9"), width = "100%"),
        selectInput("filtre_teacher", "Qualit\u00e9 enseignant", c("Tous", "Faible", "Moyen", "\u00c9lev\u00e9"), width = "100%"),
        selectInput("filtre_resources", "Acc\u00e8s ressources", c("Tous", "Faible", "Moyen", "\u00c9lev\u00e9"), width = "100%"),
        selectInput("filtre_peers", "Influence des pairs",
                    c("Tous", "N\u00e9gatif", "Neutre", "Positif"), width = "100%")
      )
    ),

    # Reset
    actionButton("reset_filtres", "R\u00e9initialiser les filtres",
                 icon = icon("rotate-left"), class = "btn-reset"),

    # Effectif
    div(class = "effectif-badge",
        icon("users", style = "margin-right: 6px;"),
        textOutput("effectif_badge", inline = TRUE)
    ),

    # Source
    div(class = "source-info",
        tags$strong("Source :"), " Student Performance Factors (Kaggle)"
    )
  ),

  # ============================================================
  # Onglet 1 : Vue d'ensemble
  # ============================================================
  nav_panel(
    title = "Vue d'ensemble",
    icon = icon("chart-line"),
    value = "vue_ensemble",
    div(
      class = "kpi-scroll-wrapper",
      div(
        class = "kpi-scroll-container",
        uiOutput("kpi_score"),
        uiOutput("kpi_reussite"),
        uiOutput("kpi_difficulte"),
        uiOutput("kpi_assiduite"),
        uiOutput("kpi_heures"),
        uiOutput("kpi_tutorat")
      )
    ),
    expand_card("Distribution des scores aux examens", "hist_scores",
      plotlyOutput("hist_scores", height = "280px"),
      help_text = "Histogramme montrant la r\u00e9partition des scores aux examens. La ligne rouge pointill\u00e9e indique la m\u00e9diane. Plus une barre est haute, plus d'\u00e9l\u00e8ves ont obtenu ce score.",
      insight = "Les scores sont tr\u00e8s concentr\u00e9s autour de 65-70. Tr\u00e8s peu d'\u00e9l\u00e8ves d\u00e9passent 75, ce qui sugg\u00e8re un plafond de performance dans ce jeu de donn\u00e9es."
    ),
    layout_columns(
      col_widths = c(6, 6),
      expand_card("Facteurs class\u00e9s par influence sur le score", "barplot_eta2",
        plotlyOutput("barplot_eta2", height = "380px"),
        help_text = "Ce graphique classe tous les facteurs selon leur influence sur le score. Chaque barre repr\u00e9sente le pourcentage de variation des scores attribuable \u00e0 ce facteur. Plus la barre est longue, plus le facteur est associ\u00e9 \u00e0 des diff\u00e9rences de scores entre \u00e9l\u00e8ves.",
        insight = "L'assiduit\u00e9 et les heures d'\u00e9tude apparaissent comme les deux facteurs les plus associ\u00e9s au score. Les facteurs socio-\u00e9conomiques et d'\u00e9tablissement semblent avoir un impact plus limit\u00e9 dans ce jeu de donn\u00e9es."
      ),
      expand_card("Corr\u00e9lations entre variables num\u00e9riques", "heatmap_cor",
        plotlyOutput("heatmap_cor", height = "380px"),
        help_text = "Matrice de corr\u00e9lation entre les variables num\u00e9riques. Les cases bleues indiquent une corr\u00e9lation positive (quand l'une augmente, l'autre aussi), les roses une corr\u00e9lation n\u00e9gative. Plus la couleur est intense, plus la relation est forte."
      )
    )
  ),

  # ============================================================
  # Onglet 2 : Facteurs eleve
  # ============================================================
  nav_panel(
    title = "Facteurs \u00e9l\u00e8ve",
    icon = icon("user-graduate"),
    layout_columns(
      col_widths = c(6, 6),
      expand_card("Assiduit\u00e9 vs Score", "scatter_att",
        plotlyOutput("scatter_att", height = "320px"),
        help_text = "Nuage de points montrant la relation entre l'assiduit\u00e9 et le score. La droite orange repr\u00e9sente la tendance lin\u00e9aire. Chaque point est un \u00e9l\u00e8ve.",
        badge_text = "31.2% de variance",
        insight = "L'assiduit\u00e9 appara\u00eet comme le facteur le plus fortement associ\u00e9 au score (r = 0.58). Les \u00e9l\u00e8ves les plus assidus tendent \u00e0 obtenir de meilleurs r\u00e9sultats."
      ),
      expand_card("Heures d'\u00e9tude vs Score", "scatter_hours",
        plotlyOutput("scatter_hours", height = "320px"),
        help_text = "Nuage de points montrant la relation entre les heures d'\u00e9tude et le score. La droite orange repr\u00e9sente la tendance lin\u00e9aire.",
        badge_text = "15.3% de variance",
        insight = "Les heures d'\u00e9tude constituent le deuxi\u00e8me facteur le plus associ\u00e9 au score (r = 0.45)."
      )
    ),
    layout_columns(
      col_widths = c(4, 4, 4),
      expand_card("Motivation vs Score", "box_motivation",
        plotlyOutput("box_motivation", height = "280px"),
        help_text = "Distribution du score selon le niveau de motivation. Les bo\u00eetes montrent la m\u00e9diane et les quartiles.",
        badge_text = "\u00e9cart ~0.9 pt"
      ),
      expand_card("Sommeil vs Score", "box_sommeil",
        plotlyOutput("box_sommeil", height = "280px"),
        help_text = "Distribution du score selon les heures de sommeil.",
        badge_text = "r \u2248 0"
      ),
      expand_card("Activit\u00e9s extrascolaires vs Score", "box_extra",
        plotlyOutput("box_extra", height = "280px"),
        help_text = "Comparaison des scores entre \u00e9l\u00e8ves avec et sans activit\u00e9s extrascolaires.",
        badge_text = "\u00e9cart ~0.5 pt"
      )
    )
  ),

  # ============================================================
  # Onglet 3 : Contexte socio-economique
  # ============================================================
  nav_panel(
    title = "Contexte socio-\u00e9co.",
    icon = icon("house"),
    layout_columns(
      col_widths = c(4, 4, 4),
      expand_card("Implication parentale vs Score", "box_parental",
        plotlyOutput("box_parental", height = "280px"),
        help_text = "Distribution du score selon le niveau d'implication parentale.",
        badge_text = "\u00e9cart ~1.7 pts",
        insight = "Les facteurs socio-\u00e9conomiques montrent des \u00e9carts de scores faibles (1 \u00e0 2 points). Leur influence individuelle semble limit\u00e9e dans ce jeu de donn\u00e9es, bien qu'un effet cumul\u00e9 de plusieurs facteurs d\u00e9favorables ne soit pas \u00e0 exclure."
      ),
      expand_card("Revenu familial vs Score", "box_income",
        plotlyOutput("box_income", height = "280px"),
        help_text = "Distribution du score selon le revenu familial.",
        badge_text = "\u00e9cart ~1 pt"
      ),
      expand_card("\u00c9ducation parentale vs Score", "box_education",
        plotlyOutput("box_education", height = "280px"),
        help_text = "Distribution du score selon le niveau d'\u00e9ducation des parents.",
        badge_text = "\u00e9cart ~1.1 pts"
      )
    ),
    layout_columns(
      col_widths = c(6, 6),
      expand_card("Acc\u00e8s internet vs Score", "box_internet",
        plotlyOutput("box_internet", height = "280px"),
        help_text = "Score moyen compar\u00e9 entre \u00e9l\u00e8ves avec et sans acc\u00e8s internet. Le nombre d'\u00e9l\u00e8ves par cat\u00e9gorie est indiqu\u00e9.",
        badge_text = "\u00e9cart ~0.8 pt"
      ),
      expand_card("Distance domicile-\u00e9cole vs Score", "box_distance",
        plotlyOutput("box_distance", height = "280px"),
        help_text = "Distribution du score selon la distance entre le domicile et l'\u00e9cole.",
        badge_text = "\u00e9cart ~1 pt"
      )
    ),
  ),

  # ============================================================
  # Onglet 4 : Environnement scolaire
  # ============================================================
  nav_panel(
    title = "Environnement scolaire",
    icon = icon("building"),
    expand_card("Acc\u00e8s aux ressources vs Score", "box_resources",
      plotlyOutput("box_resources", height = "300px"),
      help_text = "Distribution du score selon le niveau d'acc\u00e8s aux ressources p\u00e9dagogiques.",
      badge_text = "\u00e9cart ~1.9 pts",
      insight = "L'acc\u00e8s aux ressources pr\u00e9sente l'\u00e9cart le plus marqu\u00e9 parmi les facteurs d'\u00e9tablissement. Les \u00e9l\u00e8ves d\u00e9clarant un acc\u00e8s \u00e9lev\u00e9 tendent \u00e0 obtenir de meilleurs scores."
    ),
    layout_columns(
      col_widths = c(4, 4, 4),
      expand_card("Type d'\u00e9cole vs Score", "box_school",
        plotlyOutput("box_school", height = "280px"),
        help_text = "Comparaison des scores entre \u00e9coles publiques et priv\u00e9es.",
        badge_text = "\u00e9cart ~0.1 pt"
      ),
      expand_card("Qualit\u00e9 enseignante vs Score", "box_teacher",
        plotlyOutput("box_teacher", height = "280px"),
        help_text = "Distribution du score selon la qualit\u00e9 de l'enseignement per\u00e7ue.",
        badge_text = "\u00e9cart ~0.9 pt"
      ),
      expand_card("Influence des pairs vs Score", "box_peers",
        plotlyOutput("box_peers", height = "280px"),
        help_text = "Distribution du score selon le type d'influence exerc\u00e9e par les camarades.",
        badge_text = "\u00e9cart ~1 pt"
      )
    )
  ),

  # ============================================================
  # Onglet 5 : Exploration libre
  # ============================================================
  nav_panel(
    title = "Exploration libre",
    icon = icon("flask"),
    layout_columns(
      col_widths = c(6, 6),
      # Panel A
      card(
        class = "chart-card",
        card_header(class = "chart-card-header", "Exploration A"),
        card_body(
          layout_columns(
            col_widths = c(4, 4, 4),
            selectInput("explo_type_a", "Type", c("Histogramme", "Boxplot", "Nuage de points", "Bar chart"), width = "100%"),
            uiOutput("explo_x_a_ui"),
            uiOutput("explo_y_a_ui")
          ),
          plotlyOutput("explo_plot_a", height = "320px"),
          uiOutput("explo_stats_a")
        )
      ),
      # Panel B
      card(
        class = "chart-card",
        card_header(class = "chart-card-header", "Exploration B"),
        card_body(
          layout_columns(
            col_widths = c(4, 4, 4),
            selectInput("explo_type_b", "Type", c("Histogramme", "Boxplot", "Nuage de points", "Bar chart"), width = "100%"),
            uiOutput("explo_x_b_ui"),
            uiOutput("explo_y_b_ui")
          ),
          plotlyOutput("explo_plot_b", height = "320px"),
          uiOutput("explo_stats_b")
        )
      )
    )
  ),

  # ============================================================
  # Onglet 6 : Donnees
  # ============================================================
  nav_panel(
    title = "Donn\u00e9es",
    icon = icon("table"),
    card(
      class = "chart-card",
      card_header(
        class = "chart-card-header",
        "Donn\u00e9es filtr\u00e9es",
        downloadButton("download_csv", "Exporter CSV",
                       class = "btn btn-sm",
                       style = "background: #4361EE; color: white; border: none; border-radius: 8px; font-size: 0.78rem;")
      ),
      card_body(
        DTOutput("table_data")
      )
    )
  ),

  # ============================================================
  # Onglet 7 : A propos
  # ============================================================
  nav_panel(
    title = "\u00c0 propos",
    icon = icon("circle-info"),
    fillable = FALSE,

    # Hero
    div(class = "about-hero",
      tags$h2("Pilotage de la R\u00e9ussite Scolaire"),
      tags$p("Tableau de bord d\u00e9cisionnel \u00e0 destination de l'Acad\u00e9mie de Rennes. Ce dispositif vise \u00e0 identifier les facteurs influen\u00e7ant la performance scolaire des \u00e9l\u00e8ves afin d'orienter les politiques d'accompagnement et d'allocation des ressources \u00e9ducatives.")
    ),

    # Contexte + R\u00f4les
    div(class = "about-row-2", layout_columns(
      col_widths = c(6, 6),
      card(class = "chart-card about-card",
        card_body(
          tags$h4(span(class = "about-icon", icon("landmark")), "Contexte"),
          tags$table(class = "about-table",
            tags$tr(tags$td("Organisation"), tags$td("Rectorat de l'Acad\u00e9mie de Rennes")),
            tags$tr(tags$td("P\u00e9rim\u00e8tre"), tags$td("4 d\u00e9partements bretons")),
            tags$tr(tags$td("Port\u00e9e"), tags$td("R\u00e9gionale \u2014 Bretagne")),
            tags$tr(tags$td("Objectif"), tags$td("R\u00e9duire les in\u00e9galit\u00e9s et le d\u00e9crochage scolaire")),
            tags$tr(tags$td("Processus m\u00e9tier"), tags$td("Pilotage de la r\u00e9ussite scolaire"))
          )
        )
      ),
      card(class = "chart-card about-card",
        card_body(
          tags$h4(span(class = "about-icon", icon("users")), "Utilisateurs cibles"),
          div(class = "about-role",
            div(class = "about-avatar", style = "background: #4361EE;", "R"),
            div(div(class = "about-role-name", "Recteur / Directeur acad\u00e9mique"),
                div(class = "about-role-desc", "Vision strat\u00e9gique, arbitrages"))
          ),
          div(class = "about-role",
            div(class = "about-avatar", style = "background: #7209B7;", "I"),
            div(div(class = "about-role-name", "Inspecteur d'acad\u00e9mie"),
                div(class = "about-role-desc", "Diagnostic des in\u00e9galit\u00e9s, plans d'action"))
          ),
          div(class = "about-role",
            div(class = "about-avatar", style = "background: #06D6A0;", "C"),
            div(div(class = "about-role-name", "Chef d'\u00e9tablissement"),
                div(class = "about-role-desc", "Exploitation locale, leviers d'action"))
          ),
          div(class = "about-role",
            div(class = "about-avatar", style = "background: #FB8500;", "S"),
            div(div(class = "about-role-name", "Service Statistique Acad\u00e9mique"),
                div(class = "about-role-desc", "Alimentation et fiabilisation des donn\u00e9es"))
          )
        )
      )
    )),

    # Donn\u00e9es + M\u00e9thodologie + Limites
    div(class = "about-row-3", layout_columns(
      col_widths = c(4, 4, 4),
      card(class = "chart-card about-card",
        card_body(
          tags$h4(span(class = "about-icon", icon("database")), "Donn\u00e9es"),
          tags$table(class = "about-table",
            tags$tr(tags$td("Source"), tags$td("Student Performance Factors")),
            tags$tr(tags$td("Origine"), tags$td("Kaggle (open data)")),
            tags$tr(tags$td("Volume"), tags$td("6 607 observations")),
            tags$tr(tags$td("Variables"), tags$td("20 (6 num\u00e9riques, 14 cat\u00e9gorielles)"))
          ),
          div(class = "about-badges",
            span(class = "about-badge blue", "6 607 \u00e9l\u00e8ves"),
            span(class = "about-badge purple", "20 variables"),
            span(class = "about-badge green", "229 incomplets")
          )
        )
      ),
      card(class = "chart-card about-card",
        card_body(
          tags$h4(span(class = "about-icon", icon("cogs")), "M\u00e9thodologie"),
          tags$table(class = "about-table",
            tags$tr(tags$td("Valeurs manquantes"), tags$td("229 individus incomplets, exclus par d\u00e9faut")),
            tags$tr(tags$td("Outliers"), tags$td("1 score \u00e0 101 plafonn\u00e9 \u00e0 100")),
            tags$tr(tags$td("Seuil r\u00e9ussite"), tags$td("\u2265 67 (m\u00e9diane, ajustable)")),
            tags$tr(tags$td("Seuil difficult\u00e9"), tags$td("< 65 (~1er quartile, ajustable)")),
            tags$tr(tags$td("Mesure d'influence"), tags$td("Part de variance expliqu\u00e9e"))
          )
        )
      ),
      card(class = "chart-card about-card",
        card_body(
          tags$h4(span(class = "about-icon", icon("triangle-exclamation")), "Limites"),
          div(class = "about-limit",
            span(class = "about-limit-dot", "\u2022"),
            span(class = "about-limit-text", "La variance des scores est faible (\u00e9cart-type ~3.9), ce qui limite la capacit\u00e9 \u00e0 distinguer les facteurs d'influence.")
          ),
          div(class = "about-limit",
            span(class = "about-limit-dot", "\u2022"),
            span(class = "about-limit-text", "Les corr\u00e9lations observ\u00e9es ne permettent pas d'\u00e9tablir des liens de causalit\u00e9.")
          ),
          div(class = "about-limit",
            span(class = "about-limit-dot", "\u2022"),
            span(class = "about-limit-text", "Les interpr\u00e9tations propos\u00e9es sont des pistes de r\u00e9flexion, non des conclusions d\u00e9finitives.")
          )
        )
      )
    )),

    # Footer
    div(class = "about-footer",
      div("Tableau de bord r\u00e9alis\u00e9 par ", tags$strong("Desjardins Bryan"), " et ", tags$strong("Festoc Julianne")),
      div(style = "margin-top: 4px; font-size: 0.7rem; opacity: 0.8;",
        icon("desktop"), " Optimis\u00e9 pour un affichage sur \u00e9cran d'ordinateur"
      )
    )
  )
)
