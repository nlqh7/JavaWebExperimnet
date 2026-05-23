function confirmDelete(msg) {
    return confirm(msg || '确认删除？');
}

document.addEventListener('DOMContentLoaded', function() {
    var coverImgs = document.querySelectorAll('img.cover-img[data-title]');
    for (var i = 0; i < coverImgs.length; i++) {
        (function(img) {
            img.onerror = function() {
                var div = document.createElement('div');
                div.className = 'cover-placeholder cover-error';
                div.textContent = '加载失败: ' + img.getAttribute('data-title');
                img.parentNode.replaceChild(div, img);
            };
        })(coverImgs[i]);
    }

    var cards = document.querySelectorAll('.book-card[data-href]');
    for (var j = 0; j < cards.length; j++) {
        cards[j].addEventListener('click', function(e) {
            if (e.target.tagName === 'A') return;
            window.location.href = this.getAttribute('data-href');
        });
    }
});
