document$.subscribe(function() {
    // Select all tables
    var tables = document.querySelectorAll(".md-typeset__table table");

    tables.forEach(function(table) {
        // Check if the first header cell is marked as bold
        // MkDocs typically renders bold markdown text to <strong> tags within <th> elements
        var firstHeaderCell = table.querySelector("thead th:first-child strong");

        // If the first header cell exists and is bold
        if (firstHeaderCell) {
            // Initialize TableFilter for this table
            var tf = new TableFilter(table, {
                base_path: "https://unpkg.com/tablefilter@latest/dist/tablefilter/",
                // Configuration options
                alternate_rows: true,
                rows_counter: false,
                btn_reset: {
                    text: 'Clear'
                },   
                help_instructions: false,   
                responsive: true,      
                extensions: [{
                      name: 'sort'
                  }],
                mark_active_columns: {
                      highlight_column: true
                  },
                no_results_message: true,
                // Add other configuration as needed
            });

            tf.init();
        }
    });
});
