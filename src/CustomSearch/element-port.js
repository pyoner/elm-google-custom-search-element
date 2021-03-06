export function init(app) {
    const event = app.ports.event;
    app.ports.load.subscribe(function(cx) {
        // Insert it before the CSE code snippet so that cse.js can take the script
        // parameters, like parsetags, callbacks.
        window.__gcse = {
            parsetags: 'explicit',
            callback: function() {
                if (document.readyState == 'complete') {
                    // Document is ready when CSE element is initialized.
                    event.send(["Load", true, cx]);
                } else {
                    // Document is not ready yet, when CSE element is initialized.
                    google.setOnLoadCallback(function() {
                        event.send(["Load", true, cx]);
                    }, true);
                }
            }
        };

        (function() {
            const gcse = document.createElement('script');
            gcse.type = 'text/javascript';
            gcse.async = true;
            gcse.src = 'https://cse.google.com/cse.js?cx=' + cx;
            gcse.onerror = function(error) {
                event.send(["Load", false, `Can't load script for ${cx}`]);
            }
            const s = document.getElementsByTagName('script')[0];
            s.parentNode.insertBefore(gcse, s);
        })();
    });

    app.ports.render_.subscribe(function([componentConfig, opt_componentConfig]) {
        const id = componentConfig.div;
        try {
            google.search.cse.element.render(componentConfig, opt_componentConfig);
        } catch (e) {
            event.send(["Render", false, `Render error: ${e}`]);
            return;
        }
        event.send(["Render", true, componentConfig.gname]);
    });

    app.ports.clear.subscribe(function(elementId) {
        const el = document.getElementById(elementId);
        if (el) {
            el.innerHTML = "";
            event.send(["Clear", true, elementId]);
        } else {
            event.send(["Clear", false, `Can't found DOM element by id ${elementId}`]);
        }
    });

    app.ports.execute.subscribe(function([gname, query]) {
        try {
            const element = google.search.cse.element.getElement(gname);
            element.execute(query);
        } catch (e) {
            event.send(["Execute", false, `Execute error: ${e}`]);
            return;
        }
        event.send(["Execute", true, [gname, query]]);
    });

    app.ports.prefillQuery.subscribe(function([gname, query]) {
        try {
            const element = google.search.cse.element.getElement(gname);
            element.prefillQuery(query);
        } catch (e) {
            event.send(["PrefillQuery", false, `PrefillQuery error: ${e}`]);
            return;
        }
        event.send(["PrefillQuery", true, [gname, query]]);
    });

    app.ports.getInputQuery.subscribe(function(gname) {
        try {
            const element = google.search.cse.element.getElement(gname);
            const query = element.getInputQuery();
        } catch (e) {
            event.send(["InputQuery", false, `getInputQuery error: ${e}`]);
            return;
        }
        event.send(["InputQuery", true, [gname, query]]);
    });

    app.ports.clearAllResults.subscribe(function(gname) {
        try {
            const element = google.search.cse.element.getElement(gname);
            element.clearAllResults();
        } catch (e) {
            event.send(["ClearAllResults", false, `clearAllResults error: ${e}`]);
            return;
        }
        event.send(["ClearAllResults", true, gname]);
    });

}
