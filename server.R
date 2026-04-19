function(input, output, session) {

  # ============================================================
  # Donnees reactives
  # ============================================================
  data_base <- reactive({
    if (input$inclure_na) df_raw else df_clean
  })

  donnees <- reactive({
    d <- data_base()
    if (input$filtre_genre != "Tous")      d <- d %>% filter(Gender == input$filtre_genre)
    if (input$filtre_motivation != "Tous") d <- d %>% filter(Motivation_Level == input$filtre_motivation)
    if (input$filtre_extra != "Tous")      d <- d %>% filter(Extracurricular_Activities == input$filtre_extra)
    if (input$filtre_handicap != "Tous")   d <- d %>% filter(Learning_Disabilities == input$filtre_handicap)
    if (input$filtre_income != "Tous")     d <- d %>% filter(Family_Income == input$filtre_income)
    if (input$filtre_parental != "Tous")   d <- d %>% filter(Parental_Involvement == input$filtre_parental)
    if (input$filtre_internet != "Tous")   d <- d %>% filter(Internet_Access == input$filtre_internet)
    if (input$filtre_school != "Tous")     d <- d %>% filter(School_Type == input$filtre_school)
    if (input$filtre_teacher != "Tous")    d <- d %>% filter(Teacher_Quality == input$filtre_teacher)
    if (input$filtre_resources != "Tous")  d <- d %>% filter(Access_to_Resources == input$filtre_resources)
    if (input$filtre_peers != "Tous")      d <- d %>% filter(Peer_Influence == input$filtre_peers)
    if (input$filtre_education != "Tous")  d <- d %>% filter(Parental_Education_Level == input$filtre_education)
    if (input$filtre_distance != "Tous")   d <- d %>% filter(Distance_from_Home == input$filtre_distance)
    d
  })

  # Effectif
  output$effectif_badge <- renderText({
    paste0(format(nrow(donnees()), big.mark = " "), " \u00e9l\u00e8ves")
  })

  # Reset filtres
  observeEvent(input$reset_filtres, {
    updateSelectInput(session, "filtre_genre", selected = "Tous")
    updateSelectInput(session, "filtre_motivation", selected = "Tous")
    updateSelectInput(session, "filtre_extra", selected = "Tous")
    updateSelectInput(session, "filtre_handicap", selected = "Tous")
    updateSelectInput(session, "filtre_income", selected = "Tous")
    updateSelectInput(session, "filtre_parental", selected = "Tous")
    updateSelectInput(session, "filtre_internet", selected = "Tous")
    updateSelectInput(session, "filtre_school", selected = "Tous")
    updateSelectInput(session, "filtre_teacher", selected = "Tous")
    updateSelectInput(session, "filtre_resources", selected = "Tous")
    updateSelectInput(session, "filtre_peers", selected = "Tous")
    updateSelectInput(session, "filtre_education", selected = "Tous")
    updateSelectInput(session, "filtre_distance", selected = "Tous")
    updateMaterialSwitch(session, "inclure_na", value = FALSE)
  })

  # ============================================================
  # KPIs (seuils pertinents)
  # ============================================================
  output$kpi_score <- renderUI({
    val <- round(mean(donnees()$Exam_Score, na.rm = TRUE), 1)
    make_kpi(val, "Score moyen", "star", pal$kpi_gradients[1])
  })

  output$kpi_reussite <- renderUI({
    seuil <- input$seuil_reussite
    pct <- round(mean(donnees()$Exam_Score >= seuil, na.rm = TRUE) * 100, 1)
    make_kpi(
      paste0(pct, " %"),
      paste0("R\u00e9ussite (\u2265 ", seuil, ")"),
      "check-circle",
      pal$kpi_gradients[2],
      info_text = paste0(
        "Pourcentage d'\u00e9l\u00e8ves avec un score \u2265", seuil, ". ",
        "La valeur par d\u00e9faut (67) correspond \u00e0 la m\u00e9diane du jeu de donn\u00e9es, ",
        "ce qui rend l'indicateur discriminant (~50/50). ",
        "Modifiable via le curseur 'Seuils KPI' dans les filtres."
      )
    )
  })

  output$kpi_difficulte <- renderUI({
    seuil <- input$seuil_difficulte
    pct <- round(mean(donnees()$Exam_Score < seuil, na.rm = TRUE) * 100, 1)
    make_kpi(
      paste0(pct, " %"),
      paste0("En difficult\u00e9 (< ", seuil, ")"),
      "exclamation-triangle",
      pal$kpi_gradients[3],
      info_text = paste0(
        "Pourcentage d'\u00e9l\u00e8ves avec un score <", seuil, ". ",
        "La valeur par d\u00e9faut (65) correspond approximativement au 1er quartile. ",
        "Ce seuil identifie les \u00e9l\u00e8ves n\u00e9cessitant un accompagnement prioritaire. ",
        "Modifiable via le curseur 'Seuils KPI' dans les filtres."
      )
    )
  })

  output$kpi_assiduite <- renderUI({
    val <- paste0(round(mean(donnees()$Attendance, na.rm = TRUE), 1), " %")
    make_kpi(val, "Assiduit\u00e9 moyenne", "calendar-check", pal$kpi_gradients[4])
  })

  output$kpi_tutorat <- renderUI({
    pct <- round(mean(donnees()$Tutoring_Sessions >= 1, na.rm = TRUE) * 100, 1)
    make_kpi(paste0(pct, " %"), "Acc\u00e8s au tutorat", "people-arrows", pal$kpi_gradients[5])
  })

  output$kpi_heures <- renderUI({
    val <- paste0(round(mean(donnees()$Hours_Studied, na.rm = TRUE), 1), " h")
    make_kpi(val, "Heures d'\u00e9tude moy.", "clock", pal$kpi_gradients[6],
             info_text = "Moyenne des heures d'\u00e9tude par \u00e9l\u00e8ve. Facteur pr\u00e9dictif #2 (r = 0.45). Un levier partiellement actionnable via le soutien scolaire.")
  })

  # ============================================================
  # Onglet 1 : Vue d'ensemble
  # ============================================================

  # Histogramme des scores
  output$hist_scores <- renderPlotly({
    d <- donnees()
    med <- median(d$Exam_Score, na.rm = TRUE)
    p <- ggplot(d, aes(x = Exam_Score)) +
      geom_histogram(binwidth = 2, fill = pal$bleu1, color = "white", alpha = 0.85) +
      geom_vline(xintercept = med, linetype = "dashed", color = pal$danger, linewidth = 0.8) +
      annotate("text", x = med + 1.5, y = Inf, vjust = 2,
               label = paste0("M\u00e9diane = ", med), color = pal$danger,
               fontface = "bold", size = 3.2) +
      labs(x = "Score aux examens", y = "Nombre d'\u00e9l\u00e8ves") +
      theme_dashboard()
    ggplotly(p, tooltip = c("x", "y")) %>% clean_plotly()
  })

  # Heatmap de correlation
  output$heatmap_cor <- renderPlotly({
    d <- donnees()
    num_cols <- c("Attendance", "Hours_Studied", "Previous_Scores",
                  "Tutoring_Sessions", "Sleep_Hours", "Physical_Activity", "Exam_Score")
    noms <- c("Assiduit\u00e9", "Heures \u00e9tude", "Scores pr\u00e9c.", "Tutorat",
              "Sommeil", "Activit\u00e9 phys.", "Score exam")

    cor_mat <- round(cor(d[, num_cols], use = "complete.obs"), 2)

    plot_ly(
      x = noms, y = noms, z = cor_mat,
      type = "heatmap",
      colorscale = list(c(0, pal$rose), c(0.5, "#FFFFFF"), c(1, pal$bleu1)),
      zmin = -1, zmax = 1,
      text = cor_mat, hoverinfo = "text",
      showscale = TRUE
    ) %>%
      layout(
        xaxis = list(tickangle = -45, tickfont = list(size = 9)),
        yaxis = list(tickfont = list(size = 9))
      ) %>%
      clean_plotly()
  })

  # Barplot eta2
  output$barplot_eta2 <- renderPlotly({
    d <- donnees()
    all_vars <- c("Attendance", "Hours_Studied", "Previous_Scores", "Tutoring_Sessions",
                  "Sleep_Hours", "Physical_Activity",
                  "Parental_Involvement", "Family_Income", "Access_to_Resources", "Teacher_Quality",
                  "Peer_Influence", "Motivation_Level", "Parental_Education_Level",
                  "Distance_from_Home", "Internet_Access", "Extracurricular_Activities",
                  "School_Type", "Learning_Disabilities", "Gender")
    all_labels <- c("Assiduit\u00e9", "Heures d'\u00e9tude", "Scores pr\u00e9c\u00e9dents", "Tutorat",
                    "Sommeil", "Activit\u00e9 physique",
                    "Implication parentale", "Revenu familial", "Acc\u00e8s ressources", "Qualit\u00e9 enseignant",
                    "Influence pairs", "Motivation", "\u00c9ducation parentale",
                    "Distance domicile", "Acc\u00e8s internet", "Extrascolaire",
                    "Type \u00e9cole", "Troubles apprent.", "Genre")
    types <- c(rep("Num\u00e9rique", 6), rep("Cat\u00e9goriel", 13))

    etas <- sapply(seq_along(all_vars), function(i) {
      v <- all_vars[i]
      x <- d[[v]]
      y <- d$Exam_Score
      if (types[i] == "Num\u00e9rique") x <- cut(x, breaks = 4, labels = FALSE)
      calc_eta2(x, y)
    })

    result <- data.frame(
      Facteur = all_labels,
      Eta2 = round(etas, 4),
      Type = types,
      stringsAsFactors = FALSE
    )
    result <- result[order(result$Eta2), ]
    result$Facteur <- factor(result$Facteur, levels = result$Facteur)

    p <- ggplot(result, aes(x = Facteur, y = Eta2, fill = Type)) +
      geom_col(width = 0.7) +
      geom_text(aes(y = Eta2 + 0.025, label = sprintf("%.1f%%", Eta2 * 100)), hjust = 0, size = 2.8, color = "#2C3E50", fontface = "bold") +
      coord_flip() +
      scale_fill_manual(values = c("Cat\u00e9goriel" = pal$violet, "Num\u00e9rique" = pal$bleu1)) +
      scale_y_continuous(labels = scales::percent_format(), expand = expansion(mult = c(0, 0.22))) +
      labs(x = "", y = "Part de variance expliqu\u00e9e", fill = "") +
      theme_dashboard() +
      theme(legend.position = "top")
    ggplotly(p, tooltip = c("y")) %>% clean_plotly()
  })

  # ============================================================
  # Onglet 2 : Facteurs eleve
  # ============================================================

  # Scatter Attendance vs Score avec tendance
  output$scatter_att <- renderPlotly({
    d <- donnees()
    r <- round(cor(d$Attendance, d$Exam_Score, use = "complete.obs"), 3)
    p <- ggplot(d, aes(x = Attendance, y = Exam_Score)) +
      geom_point(alpha = 0.15, color = pal$bleu1, size = 1) +
      geom_smooth(method = "lm", color = pal$orange, fill = pal$orange,
                  alpha = 0.15, linewidth = 1) +
      labs(x = "Assiduit\u00e9 (%)", y = "Score",
           subtitle = paste0("r = ", r)) +
      theme_dashboard()
    ggplotly(p, tooltip = c("x", "y")) %>% clean_plotly()
  })

  # Scatter Hours vs Score avec tendance
  output$scatter_hours <- renderPlotly({
    d <- donnees()
    r <- round(cor(d$Hours_Studied, d$Exam_Score, use = "complete.obs"), 3)
    p <- ggplot(d, aes(x = Hours_Studied, y = Exam_Score)) +
      geom_point(alpha = 0.15, color = pal$bleu1, size = 1) +
      geom_smooth(method = "lm", color = pal$orange, fill = pal$orange,
                  alpha = 0.15, linewidth = 1) +
      labs(x = "Heures d'\u00e9tude", y = "Score") +
      theme_dashboard()
    ggplotly(p, tooltip = c("x", "y")) %>% clean_plotly()
  })

  # Boxplot motivation
  output$box_motivation <- renderPlotly({
    d <- donnees()
    p <- ggplot(d, aes(x = Motivation_Level, y = Exam_Score, fill = Motivation_Level)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$ord3) +
      labs(x = "Motivation", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  # Boxplot sommeil
  output$box_sommeil <- renderPlotly({
    d <- donnees()
    p <- ggplot(d, aes(x = factor(Sleep_Hours), y = Exam_Score)) +
      geom_boxplot(fill = pal$bleu3, alpha = 0.7, outlier.alpha = 0.3) +
      labs(x = "Heures de sommeil", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  # Boxplot extrascolaire
  output$box_extra <- renderPlotly({
    d <- donnees()
    p <- ggplot(d, aes(x = Extracurricular_Activities, y = Exam_Score,
                       fill = Extracurricular_Activities)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$cat2) +
      labs(x = "Activit\u00e9s extrascolaires", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  # ============================================================
  # Onglet 3 : Contexte socio-economique
  # ============================================================
  output$box_income <- renderPlotly({
    p <- ggplot(donnees(), aes(x = Family_Income, y = Exam_Score, fill = Family_Income)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$ord3) +
      labs(x = "Revenu familial", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  output$box_parental <- renderPlotly({
    p <- ggplot(donnees(), aes(x = Parental_Involvement, y = Exam_Score,
                               fill = Parental_Involvement)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$ord3) +
      labs(x = "Implication parentale", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  output$box_education <- renderPlotly({
    d <- donnees() %>% filter(!is.na(Parental_Education_Level))
    p <- ggplot(d, aes(x = Parental_Education_Level, y = Exam_Score,
                       fill = Parental_Education_Level)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$cat3) +
      labs(x = "\u00c9ducation parentale", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  output$box_internet <- renderPlotly({
    d <- donnees() %>%
      group_by(Internet_Access) %>%
      summarise(n = n(), Score = round(mean(Exam_Score, na.rm = TRUE), 1), .groups = "drop")
    p <- ggplot(d, aes(x = Internet_Access, y = Score, fill = Internet_Access)) +
      geom_col(show.legend = FALSE, width = 0.5) +
      geom_text(aes(label = paste0(Score, "\n(n=", n, ")")), vjust = -0.3, size = 3, color = "#2C3E50") +
      scale_fill_manual(values = pal$cat2) +
      coord_cartesian(ylim = c(0, max(d$Score) * 1.15)) +
      labs(x = "Acc\u00e8s internet", y = "Score moyen") +
      theme_dashboard()
    ggplotly(p, tooltip = c("y")) %>% clean_plotly()
  })

  output$box_distance <- renderPlotly({
    d <- donnees() %>% filter(!is.na(Distance_from_Home))
    p <- ggplot(d, aes(x = Distance_from_Home, y = Exam_Score, fill = Distance_from_Home)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$cat3) +
      labs(x = "Distance domicile-\u00e9cole", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  # ============================================================
  # Onglet 4 : Environnement scolaire
  # ============================================================
  output$box_school <- renderPlotly({
    p <- ggplot(donnees(), aes(x = School_Type, y = Exam_Score, fill = School_Type)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$cat2) +
      labs(x = "Type d'\u00e9cole", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  output$box_teacher <- renderPlotly({
    d <- donnees() %>% filter(!is.na(Teacher_Quality))
    p <- ggplot(d, aes(x = Teacher_Quality, y = Exam_Score, fill = Teacher_Quality)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$ord3) +
      labs(x = "Qualit\u00e9 enseignante", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  output$box_peers <- renderPlotly({
    p <- ggplot(donnees(), aes(x = Peer_Influence, y = Exam_Score, fill = Peer_Influence)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$cat3) +
      labs(x = "Influence des pairs", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  output$box_resources <- renderPlotly({
    p <- ggplot(donnees(), aes(x = Access_to_Resources, y = Exam_Score,
                               fill = Access_to_Resources)) +
      geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
      scale_fill_manual(values = pal$ord3) +
      labs(x = "Acc\u00e8s aux ressources", y = "Score") +
      theme_dashboard()
    ggplotly(p) %>% clean_plotly()
  })

  # ============================================================
  # Modals pour agrandir les graphiques
  # ============================================================
  titres_graphes <- list(
    hist_scores   = "Distribution des scores aux examens",
    barplot_eta2  = "Facteurs class\u00e9s par influence sur le score",
    heatmap_cor   = "Matrice de corr\u00e9lation",
    scatter_att   = "Assiduit\u00e9 vs Score",
    scatter_hours = "Heures d'\u00e9tude vs Score",
    box_motivation = "Motivation vs Score",
    box_sommeil   = "Sommeil vs Score",
    box_extra     = "Activit\u00e9s extrascolaires vs Score",
    box_income    = "Revenu familial vs Score",
    box_parental  = "Implication parentale vs Score",
    box_education = "\u00c9ducation parentale vs Score",
    box_internet  = "Acc\u00e8s internet vs Score",
    box_distance  = "Distance domicile-\u00e9cole vs Score",
    box_school    = "Type d'\u00e9cole vs Score",
    box_teacher   = "Qualit\u00e9 enseignante vs Score",
    box_peers     = "Influence des pairs vs Score",
    box_resources = "Acc\u00e8s aux ressources vs Score"
  )

  # Textes d'aide et insights pour les modals
  help_texts <- list(
    hist_scores = "Histogramme montrant la r\u00e9partition des scores. La ligne rouge indique la m\u00e9diane.",
    barplot_eta2 = "Facteurs class\u00e9s par influence. Chaque barre repr\u00e9sente le pourcentage de variation des scores attribuable \u00e0 ce facteur.",
    heatmap_cor = "Matrice de corr\u00e9lation. Bleu = corr\u00e9lation positive, rose = n\u00e9gative.",
    scatter_att = "Nuage de points assiduit\u00e9 vs score. La droite orange montre la tendance.",
    scatter_hours = "Nuage de points heures d'\u00e9tude vs score. La droite orange montre la tendance.",
    box_motivation = "Distribution du score selon le niveau de motivation.",
    box_sommeil = "Distribution du score selon les heures de sommeil.",
    box_extra = "Comparaison des scores avec/sans activit\u00e9s extrascolaires.",
    box_income = "Distribution du score selon le revenu familial.",
    box_parental = "Distribution du score selon l'implication parentale.",
    box_education = "Distribution du score selon l'\u00e9ducation des parents.",
    box_internet = "Score moyen compar\u00e9 selon l'acc\u00e8s internet.",
    box_distance = "Distribution du score selon la distance domicile-\u00e9cole.",
    box_school = "Comparaison des scores entre \u00e9coles publiques et priv\u00e9es.",
    box_teacher = "Distribution du score selon la qualit\u00e9 enseignante.",
    box_peers = "Distribution du score selon l'influence des pairs.",
    box_resources = "Distribution du score selon l'acc\u00e8s aux ressources."
  )

  insights <- list(
    hist_scores = "Les scores sont tr\u00e8s concentr\u00e9s autour de 65-70. Tr\u00e8s peu d'\u00e9l\u00e8ves d\u00e9passent 75.",
    barplot_eta2 = "L'assiduit\u00e9 et les heures d'\u00e9tude apparaissent comme les facteurs les plus associ\u00e9s au score.",
    scatter_att = "L'assiduit\u00e9 appara\u00eet comme le facteur le plus fortement associ\u00e9 au score (r = 0.58).",
    scatter_hours = "Les heures d'\u00e9tude constituent le deuxi\u00e8me facteur le plus associ\u00e9 au score (r = 0.45).",
    box_parental = "Les facteurs socio-\u00e9conomiques montrent des \u00e9carts faibles (1 \u00e0 2 pts). Un effet cumul\u00e9 n'est pas \u00e0 exclure.",
    box_resources = "L'acc\u00e8s aux ressources pr\u00e9sente l'\u00e9cart le plus marqu\u00e9 parmi les facteurs d'\u00e9tablissement."
  )

  open_modal <- function(plot_id) {
    n <- nrow(donnees())
    # "?" tooltip
    help_el <- NULL
    if (!is.null(help_texts[[plot_id]])) {
      help_el <- tooltip(
        bs_icon("question-circle", class = "chart-help-icon"),
        help_texts[[plot_id]], placement = "top"
      )
    }
    # Ampoule tooltip
    insight_el <- NULL
    if (!is.null(insights[[plot_id]])) {
      insight_el <- tooltip(
        span(class = "chart-insight-icon", icon("lightbulb")),
        paste0("Interpr\u00e9tation possible : ", insights[[plot_id]]),
        placement = "bottom"
      )
    }
    showModal(modalDialog(
      title = div(
        style = "display: flex; justify-content: space-between; align-items: center; width: 100%;",
        span(style = "font-weight: 600;", titres_graphes[[plot_id]], help_el, insight_el),
        span(style = "font-size: 0.8rem; color: #ADB5BD;",
             icon("users"), format(n, big.mark = " "), " individus")
      ),
      plotlyOutput(paste0("modal_", plot_id), height = "65vh"),
      size = "xl",
      easyClose = TRUE,
      footer = modalButton("Fermer")
    ))
  }

  # Creer les observeEvent et modal renders pour chaque graphique
  lapply(names(titres_graphes), function(plot_id) {
    observeEvent(input[[paste0("expand_", plot_id)]], {
      open_modal(plot_id)
    })
    output[[paste0("modal_", plot_id)]] <- renderPlotly({
      # Reutiliser le meme render que le graphique principal
      # en reconstruisant le graphique
      get(paste0("build_", plot_id), envir = environment(), inherits = TRUE)
    })
  })

  # Approach simplifiee : les modals reutilisent les memes outputs
  # via plotlyProxy (pas possible directement) -> on duplique le rendu
  # dans les modal renders
  lapply(names(titres_graphes), function(pid) {
    output[[paste0("modal_", pid)]] <- renderPlotly({
      # Re-trigger le meme output
      # On utilise une approche par switch
      d <- donnees()
      p <- switch(pid,
        "hist_scores" = {
          med <- median(d$Exam_Score, na.rm = TRUE)
          ggplot(d, aes(x = Exam_Score)) +
            geom_histogram(binwidth = 2, fill = pal$bleu1, color = "white", alpha = 0.85) +
            geom_vline(xintercept = med, linetype = "dashed", color = pal$danger, linewidth = 0.8) +
            annotate("text", x = med + 1.5, y = Inf, vjust = 2,
                     label = paste0("M\u00e9diane = ", med), color = pal$danger, fontface = "bold", size = 3.5) +
            labs(x = "Score aux examens", y = "Nombre d'\u00e9l\u00e8ves") + theme_dashboard()
        },
        "barplot_eta2" = {
          NULL  # handled separately below
        },
        "scatter_att" = {
          ggplot(d, aes(x = Attendance, y = Exam_Score)) +
            geom_point(alpha = 0.15, color = pal$bleu1, size = 1.5) +
            geom_smooth(method = "lm", color = pal$orange, fill = pal$orange, alpha = 0.15, linewidth = 1.2) +
            labs(x = "Assiduit\u00e9 (%)", y = "Score") + theme_dashboard()
        },
        "scatter_hours" = {
          ggplot(d, aes(x = Hours_Studied, y = Exam_Score)) +
            geom_point(alpha = 0.15, color = pal$bleu1, size = 1.5) +
            geom_smooth(method = "lm", color = pal$orange, fill = pal$orange, alpha = 0.15, linewidth = 1.2) +
            labs(x = "Heures d'\u00e9tude", y = "Score") + theme_dashboard()
        },
        "box_motivation" = {
          ggplot(d, aes(x = Motivation_Level, y = Exam_Score, fill = Motivation_Level)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$ord3) +
            labs(x = "Motivation", y = "Score") + theme_dashboard()
        },
        "box_sommeil" = {
          ggplot(d, aes(x = factor(Sleep_Hours), y = Exam_Score)) +
            geom_boxplot(fill = pal$bleu3, alpha = 0.7, outlier.alpha = 0.3) +
            labs(x = "Heures de sommeil", y = "Score") + theme_dashboard()
        },
        "box_extra" = {
          ggplot(d, aes(x = Extracurricular_Activities, y = Exam_Score, fill = Extracurricular_Activities)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$cat2) +
            labs(x = "Activit\u00e9s extrascolaires", y = "Score") + theme_dashboard()
        },
        "box_income" = {
          ggplot(d, aes(x = Family_Income, y = Exam_Score, fill = Family_Income)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$ord3) +
            labs(x = "Revenu familial", y = "Score") + theme_dashboard()
        },
        "box_parental" = {
          ggplot(d, aes(x = Parental_Involvement, y = Exam_Score, fill = Parental_Involvement)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$ord3) +
            labs(x = "Implication parentale", y = "Score") + theme_dashboard()
        },
        "box_education" = {
          ggplot(d %>% filter(!is.na(Parental_Education_Level)),
                 aes(x = Parental_Education_Level, y = Exam_Score, fill = Parental_Education_Level)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$cat3) +
            labs(x = "\u00c9ducation parentale", y = "Score") + theme_dashboard()
        },
        "box_internet" = {
          agg <- d %>% group_by(Internet_Access) %>%
            summarise(n = n(), Score = round(mean(Exam_Score, na.rm = TRUE), 1), .groups = "drop")
          ggplot(agg, aes(x = Internet_Access, y = Score, fill = Internet_Access)) +
            geom_col(show.legend = FALSE, width = 0.5) +
            geom_text(aes(label = paste0(Score, "\n(n=", n, ")")), vjust = -0.3, size = 3.5) +
            scale_fill_manual(values = pal$cat2) +
            coord_cartesian(ylim = c(0, max(agg$Score) * 1.15)) +
            labs(x = "Acc\u00e8s internet", y = "Score moyen") + theme_dashboard()
        },
        "box_distance" = {
          ggplot(d %>% filter(!is.na(Distance_from_Home)),
                 aes(x = Distance_from_Home, y = Exam_Score, fill = Distance_from_Home)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$cat3) +
            labs(x = "Distance domicile-\u00e9cole", y = "Score") + theme_dashboard()
        },
        "box_school" = {
          ggplot(d, aes(x = School_Type, y = Exam_Score, fill = School_Type)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$cat2) +
            labs(x = "Type d'\u00e9cole", y = "Score") + theme_dashboard()
        },
        "box_teacher" = {
          ggplot(d %>% filter(!is.na(Teacher_Quality)),
                 aes(x = Teacher_Quality, y = Exam_Score, fill = Teacher_Quality)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$ord3) +
            labs(x = "Qualit\u00e9 enseignante", y = "Score") + theme_dashboard()
        },
        "box_peers" = {
          ggplot(d, aes(x = Peer_Influence, y = Exam_Score, fill = Peer_Influence)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$cat3) +
            labs(x = "Influence des pairs", y = "Score") + theme_dashboard()
        },
        "box_resources" = {
          ggplot(d, aes(x = Access_to_Resources, y = Exam_Score, fill = Access_to_Resources)) +
            geom_boxplot(outlier.alpha = 0.3, show.legend = FALSE) +
            scale_fill_manual(values = pal$ord3) +
            labs(x = "Acc\u00e8s aux ressources", y = "Score") + theme_dashboard()
        }
      )

      if (pid == "heatmap_cor") {
        num_cols <- c("Attendance", "Hours_Studied", "Previous_Scores",
                      "Tutoring_Sessions", "Sleep_Hours", "Physical_Activity", "Exam_Score")
        noms <- c("Assiduit\u00e9", "Heures \u00e9tude", "Scores pr\u00e9c.", "Tutorat",
                  "Sommeil", "Activit\u00e9 phys.", "Score exam")
        cor_mat <- round(cor(d[, num_cols], use = "complete.obs"), 2)
        plot_ly(x = noms, y = noms, z = cor_mat, type = "heatmap",
                colorscale = list(c(0, pal$rose), c(0.5, "#FFFFFF"), c(1, pal$bleu1)),
                zmin = -1, zmax = 1, text = cor_mat, hoverinfo = "text") %>%
          layout(xaxis = list(tickangle = -45)) %>% clean_plotly()
      } else if (pid == "barplot_eta2") {
        # Reutiliser le meme render
        all_vars <- c("Attendance", "Hours_Studied", "Previous_Scores", "Tutoring_Sessions",
                      "Sleep_Hours", "Physical_Activity",
                      "Parental_Involvement", "Family_Income", "Access_to_Resources", "Teacher_Quality",
                      "Peer_Influence", "Motivation_Level", "Parental_Education_Level",
                      "Distance_from_Home", "Internet_Access", "Extracurricular_Activities",
                      "School_Type", "Learning_Disabilities", "Gender")
        all_labels <- c("Assiduit\u00e9", "Heures d'\u00e9tude", "Scores pr\u00e9c\u00e9dents", "Tutorat",
                        "Sommeil", "Activit\u00e9 physique", "Implication parentale", "Revenu familial",
                        "Acc\u00e8s ressources", "Qualit\u00e9 enseignant", "Influence pairs", "Motivation",
                        "\u00c9ducation parentale", "Distance domicile", "Acc\u00e8s internet", "Extrascolaire",
                        "Type \u00e9cole", "Troubles apprent.", "Genre")
        types <- c(rep("Num\u00e9rique", 6), rep("Cat\u00e9goriel", 13))
        etas <- sapply(seq_along(all_vars), function(i) {
          x <- d[[all_vars[i]]]; if (types[i] == "Num\u00e9rique") x <- cut(x, 4, labels = FALSE)
          calc_eta2(x, d$Exam_Score)
        })
        result <- data.frame(Facteur = all_labels, Eta2 = round(etas, 4), Type = types, stringsAsFactors = FALSE)
        result <- result[order(result$Eta2), ]; result$Facteur <- factor(result$Facteur, levels = result$Facteur)
        pp <- ggplot(result, aes(x = Facteur, y = Eta2, fill = Type)) +
          geom_col(width = 0.7) +
          geom_text(aes(y = Eta2 + 0.025, label = sprintf("%.1f%%", Eta2*100)), hjust = 0, size = 3, color = "#2C3E50", fontface = "bold") +
          coord_flip() +
          scale_fill_manual(values = c("Cat\u00e9goriel" = pal$violet, "Num\u00e9rique" = pal$bleu1)) +
          scale_y_continuous(labels = scales::percent_format(), expand = expansion(mult = c(0, 0.22))) +
          labs(x = "", y = "Part de variance expliqu\u00e9e", fill = "") +
          theme_dashboard() + theme(legend.position = "top")
        ggplotly(pp, tooltip = c("y")) %>% clean_plotly()
      } else {
        ggplotly(p) %>% clean_plotly()
      }
    })
  })

  # ============================================================
  # Onglet 5 : Exploration libre
  # ============================================================
  make_explo <- function(suffix) {
    # UI Variable X
    output[[paste0("explo_x_", suffix, "_ui")]] <- renderUI({
      type <- input[[paste0("explo_type_", suffix)]]
      req(type)
      choix <- switch(type,
        "Histogramme"     = setNames(vars_num, labels_fr[vars_num]),
        "Nuage de points" = setNames(vars_num, labels_fr[vars_num]),
        "Boxplot"         = setNames(vars_cat, labels_fr[vars_cat]),
        "Bar chart"       = setNames(vars_cat, labels_fr[vars_cat])
      )
      selectInput(paste0("explo_x_", suffix), "Variable X", choices = choix, width = "100%")
    })

    # UI Variable Y (conditionnel)
    output[[paste0("explo_y_", suffix, "_ui")]] <- renderUI({
      type <- input[[paste0("explo_type_", suffix)]]
      req(type)
      if (type %in% c("Histogramme", "Bar chart")) return(NULL)
      if (type == "Nuage de points") {
        choix <- setNames(vars_num, labels_fr[vars_num])
      } else {
        choix <- setNames(vars_num, labels_fr[vars_num])
      }
      selectInput(paste0("explo_y_", suffix), "Variable Y",
                  choices = choix, selected = "Exam_Score", width = "100%")
    })

    # Graphique
    output[[paste0("explo_plot_", suffix)]] <- renderPlotly({
      type <- input[[paste0("explo_type_", suffix)]]
      var_x <- input[[paste0("explo_x_", suffix)]]
      var_y <- input[[paste0("explo_y_", suffix)]]
      req(type, var_x)
      d <- donnees()

      p <- switch(type,
        "Histogramme" = {
          req(var_x %in% names(d))
          ggplot(d, aes(x = .data[[var_x]])) +
            geom_histogram(binwidth = 2, fill = pal$bleu1, color = "white", alpha = 0.85) +
            labs(x = labels_fr[var_x], y = "Nombre d'\u00e9l\u00e8ves") + theme_dashboard()
        },
        "Boxplot" = {
          req(var_x %in% names(d))
          y_var <- if (!is.null(var_y) && var_y %in% names(d)) var_y else "Exam_Score"
          ggplot(d, aes(x = .data[[var_x]], y = .data[[y_var]])) +
            geom_boxplot(fill = pal$bleu1, alpha = 0.7, outlier.alpha = 0.3) +
            labs(x = labels_fr[var_x], y = labels_fr[y_var]) + theme_dashboard()
        },
        "Nuage de points" = {
          req(var_x %in% names(d), var_y %in% names(d))
          ggplot(d, aes(x = .data[[var_x]], y = .data[[var_y]])) +
            geom_point(alpha = 0.15, color = pal$bleu1, size = 1) +
            geom_smooth(method = "lm", color = pal$orange, fill = pal$orange, alpha = 0.15) +
            labs(x = labels_fr[var_x], y = labels_fr[var_y]) + theme_dashboard()
        },
        "Bar chart" = {
          req(var_x %in% names(d))
          agg <- d %>%
            filter(.data[[var_x]] != "") %>%
            group_by(Categorie = .data[[var_x]]) %>%
            summarise(Score = round(mean(Exam_Score, na.rm = TRUE), 1),
                      n = n(), .groups = "drop")
          ggplot(agg, aes(x = Categorie, y = Score, fill = Categorie)) +
            geom_col(show.legend = FALSE, width = 0.6) +
            geom_text(aes(label = paste0(Score, "\n(n=", n, ")")),
                      vjust = -0.3, size = 3, color = "#2C3E50") +
            scale_fill_manual(values = rep(c(pal$bleu1, pal$violet, pal$vert,
                                             pal$orange, pal$rose), 5)) +
            coord_cartesian(ylim = c(0, max(agg$Score) * 1.18)) +
            labs(x = labels_fr[var_x], y = "Score moyen") + theme_dashboard()
        }
      )
      ggplotly(p) %>% clean_plotly()
    })

    # Stats panel
    output[[paste0("explo_stats_", suffix)]] <- renderUI({
      type <- input[[paste0("explo_type_", suffix)]]
      var_x <- input[[paste0("explo_x_", suffix)]]
      var_y <- input[[paste0("explo_y_", suffix)]]
      req(type, var_x)
      d <- donnees()

      stats <- switch(type,
        "Histogramme" = {
          req(var_x %in% names(d))
          vals <- d[[var_x]]
          tagList(
            span(class = "stat-badge", paste0("Moyenne : ", round(mean(vals, na.rm = TRUE), 1))),
            span(class = "stat-badge", paste0("M\u00e9diane : ", round(median(vals, na.rm = TRUE), 1))),
            span(class = "stat-badge", paste0("\u00c9cart-type : ", round(sd(vals, na.rm = TRUE), 2))),
            span(class = "stat-badge", paste0("Min : ", min(vals, na.rm = TRUE))),
            span(class = "stat-badge", paste0("Max : ", max(vals, na.rm = TRUE)))
          )
        },
        "Nuage de points" = {
          req(var_x %in% names(d), var_y %in% names(d))
          r <- round(cor(d[[var_x]], d[[var_y]], use = "complete.obs"), 3)
          interp <- if (abs(r) > 0.5) "forte" else if (abs(r) > 0.3) "mod\u00e9r\u00e9e" else "faible"
          tagList(
            span(class = "stat-badge", paste0("r = ", r)),
            span(class = "stat-badge", paste0("R2 = ", round(r^2, 3))),
            span(class = "stat-badge", paste0("Corr\u00e9lation ", interp)),
            span(class = "stat-badge", paste0("n = ", nrow(d)))
          )
        },
        "Boxplot" = {
          req(var_x %in% names(d))
          y_var <- if (!is.null(var_y) && var_y %in% names(d)) var_y else "Exam_Score"
          agg <- d %>% filter(.data[[var_x]] != "") %>%
            group_by(.data[[var_x]]) %>%
            summarise(moy = round(mean(.data[[y_var]], na.rm = TRUE), 1), n = n(), .groups = "drop")
          ecart <- max(agg$moy) - min(agg$moy)
          tagList(
            lapply(1:nrow(agg), function(i) {
              span(class = "stat-badge", paste0(agg[[1]][i], " : ", agg$moy[i], " (n=", agg$n[i], ")"))
            }),
            span(class = "stat-badge", paste0("\u00c9cart max : ", round(ecart, 1), " pts"))
          )
        },
        "Bar chart" = {
          req(var_x %in% names(d))
          agg <- d %>% filter(.data[[var_x]] != "") %>%
            group_by(.data[[var_x]]) %>%
            summarise(moy = round(mean(Exam_Score, na.rm = TRUE), 1), n = n(), .groups = "drop")
          ecart <- max(agg$moy) - min(agg$moy)
          best <- agg[[1]][which.max(agg$moy)]
          tagList(
            span(class = "stat-badge", paste0("Meilleur : ", best, " (", max(agg$moy), ")")),
            span(class = "stat-badge", paste0("\u00c9cart max : ", round(ecart, 1), " pts")),
            span(class = "stat-badge", paste0("n total = ", sum(agg$n)))
          )
        }
      )

      div(class = "explo-stats",
          div(class = "explo-stats-title", icon("chart-bar"), " Statistiques"),
          stats)
    })
  }

  make_explo("a")
  make_explo("b")

  # ============================================================
  # Onglet 6 : Donnees
  # ============================================================
  output$table_data <- renderDT({
    d <- donnees() %>% select(-has_blank)
    noms_fr <- c(
      Hours_Studied = "Heures d'\u00e9tude", Attendance = "Assiduit\u00e9",
      Parental_Involvement = "Implication parentale", Access_to_Resources = "Acc\u00e8s ressources",
      Extracurricular_Activities = "Extrascolaire", Sleep_Hours = "Sommeil (h)",
      Previous_Scores = "Scores pr\u00e9c.", Motivation_Level = "Motivation",
      Internet_Access = "Internet", Tutoring_Sessions = "Tutorat",
      Family_Income = "Revenu", Teacher_Quality = "Qualit\u00e9 ens.",
      School_Type = "\u00c9cole", Peer_Influence = "Pairs",
      Physical_Activity = "Sport (h)", Learning_Disabilities = "Handicap",
      Parental_Education_Level = "\u00c9duc. parents", Distance_from_Home = "Distance",
      Gender = "Genre", Exam_Score = "Score"
    )
    for (old_name in names(noms_fr)) {
      if (old_name %in% names(d)) names(d)[names(d) == old_name] <- noms_fr[old_name]
    }

    datatable(
      d,
      filter = "top",
      options = list(
        pageLength = 20,
        scrollX = TRUE,
        language = list(
          search = "Rechercher :",
          lengthMenu = "Afficher _MENU_ lignes",
          info = "_START_ \u00e0 _END_ sur _TOTAL_",
          paginate = list(previous = "Pr\u00e9c.", `next` = "Suiv.")
        )
      ),
      rownames = FALSE
    )
  })

  output$download_csv <- downloadHandler(
    filename = function() {
      paste0("donnees_filtrees_", Sys.Date(), ".csv")
    },
    content = function(file) {
      write.csv(donnees() %>% select(-has_blank), file, row.names = FALSE)
    }
  )
}
