library(shiny)
library(ggplot2)
library(dplyr)
library(DT)

# =========================================================================
# 1. GENERATE MOCK HISTORICAL DATA (e.g., User Login & Navigation Logs)
# =========================================================================
set.seed(42) # Ensure reproducibility
dates <- seq(as.Date("2026-09-01"), as.Date("2026-09-30"), by = "day")

history_db <- data.frame(
  Timestamp = seq(from = as.POSIXct("2026-09-01 08:00:00"), 
                  to = as.POSIXct("2026-09-30 22:00:00"), 
                  length.out = 250),
  User = sample(c("admin_user", "developer_01", "guest_account", "analyst_beta"), 250, replace = TRUE),
  Action = sample(c("User Login", "Route Calculated", "Database Backup", "Failed Password Attempt"), 250, replace = TRUE, prob = c(0.4, 0.3, 0.1, 0.2)),
  IP_Address = sample(c("192.168.1.50", "10.0.0.12", "172.16.254.1", "192.168.1.99"), 250, replace = TRUE),
  Status = sample(c("Success", "Warning", "Critical"), 250, replace = TRUE, prob = c(0.7, 0.2, 0.1))
)

# =========================================================================
# 2. USER INTERFACE (UI) LAYOUT
# =========================================================================
ui <- fluidPage(
  # Application Title
  titlePanel("📜 System Audit & Navigation History Log"),
  
  sidebarLayout(
    sidebarPanel(
      h4("Filter History"),
      hr(),
      # Date Range Filter
      dateRangeInput("date_range", "Select Date Range:",
                     start = min(as.Date(history_db$Timestamp)),
                     end   = max(as.Date(history_db$Timestamp))),
      
      # Event Action Dropdown Filter
      selectInput("action_filter", "Filter by Action Type:",
                  choices = c("All Actions", unique(as.character(history_db$Action)))),
      
      br(),
      helpText("This history engine securely tracks all backend operations, user authentications, and automated route calculations.")
    ),
    
    mainPanel(
      # Top Element: Visual Timeline of Events
      h4("📊 Event Volume Trend over Time"),
      plotOutput("timeline_plot", height = "300px"),
      
      hr(),
      
      # Bottom Element: Searchable Data Table
      h4("📋 Tabular History Ledger"),
      DTOutput("history_table")
    )
  )
)

# =========================================================================
# 3. SERVER-SIDE PROCESSING LOGIC
# =========================================================================
server <- function(input, output, session) {
  
  # Reactive block: Filters data dynamically based on user selections
  filtered_data <- reactive({
    data <- history_db %>%
      filter(as.Date(Timestamp) >= input$date_range[1] & 
             as.Date(Timestamp) <= input$date_range[2])
    
    if (input$action_filter != "All Actions") {
      data <- data %>% filter(Action == input$action_filter)
    }
    
    return(data)
  })
  
  # Render the Timeline Trend Plot
  output/timeline_plot <- renderPlot({
    req(nrow(filtered_data()) > 0) # Ensure data exists before plotting
    
    ggplot(filtered_data(), aes(x = Timestamp, fill = Status)) +
      geom_histogram(bins = 30, color = "#ffffff", alpha = 0.8) +
      scale_fill_manual(values = c("Success" = "#2ecc71", "Warning" = "#f1c40f", "Critical" = "#e74c3c")) +
      theme_minimal(base_size = 14) +
      labs(x = "Timeline", y = "Activity Count", fill = "Severity Level") +
      theme(legend.position = "bottom")
  })
  
  # Render the Interactive Data Table
  output/history_table <- renderDT({
    datatable(
      filtered_data(),
      options = list(pageLength = 10, order = list(0, 'desc')), # Order by latest Timestamp first
      class = 'cell-border stripe',
      rownames = FALSE
    )
  })
}

# =========================================================================
# 4. LAUNCH THE WEB APPLICATION
# =========================================================================
shinyApp(ui = ui, server = server)
