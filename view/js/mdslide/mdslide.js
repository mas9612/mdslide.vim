(function() {
    initialize();

    // window.setInterval(updateContent, 1000);
})();

function initialize() {
    var content = document.getElementById('content');

    var section = document.createElement('section');
    // TODO: change to be able to change their value from vimrc parameter
    section.setAttribute('data-markdown', '');  // add attribute without value
    section.setAttribute('data-separator', '^\r?\n---\r?\n$');
    section.setAttribute('data-separator-vertical', '^\r?\n\r?\n\r?\n');
    section.setAttribute('data-separator-notes', '^note:');
    section.setAttribute('data-charset', 'utf-8');

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
        var last_updated = localStorage.getItem('mdslide_last_refresh');
        var last_modified = last_modified();

        console.log('last_updated: ' + last_updated);
        console.log('last_modified: ' + last_modified);

        if (last_modified > last_updated) {
            // need to update slide
            location.reload();
        }

    });
}
