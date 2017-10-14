(function() {
    initialize();

    window.setInterval(updateContent, 1000);
})();

function initialize() {
    var content = document.getElementById('content');

    var section = document.createElement('section');
    section.setAttribute('data-markdown', '');  // add attribute without value
    section.setAttribute('data-separator', '{{ separator }}');
    section.setAttribute('data-separator-vertical', '{{ separator_vertical }}');
    section.setAttribute('data-separator-notes', '{{ separator_notes }}');
    section.setAttribute('data-charset', '{{ charset }}');

    var time = Math.round(Date.now() / 1000);
    localStorage.setItem('mdslide_last_refresh', time);

    $.getScript('js/mdslide/contents.js', function() {
        content.appendChild(section);

        var script = document.createElement('script');
        script.type = 'text/template';
        script.textContent = contents();

        section.appendChild(script);
    });
}

function updateContent() {
    $.getScript('js/mdslide/contents.js', function() {
        var last_updated_time = localStorage.getItem('mdslide_last_refresh');
        var last_modified_time = last_modified();

        if (last_modified_time > last_updated_time) {
            // need to update slide
            location.reload();
        }

    });
}
