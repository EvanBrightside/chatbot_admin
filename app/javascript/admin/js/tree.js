// Treant.js rendering

// $(function() {
  function initChatTree() {
    var chat_tree_selector = '#chat-tree'
    var chat_tree_node = $(chat_tree_selector)

    if(!chat_tree_node.length) return;

    var chat_tree_config = {
      chart: {
    	container: chat_tree_selector,
        rootOrientation: "WEST",
        nodeAlign: "BOTTOM",
        levelSeparation: 115,
        siblingSeparation: 40,

        node: {
          HTMLclass: "chat-tree-node"
        },
        connectors: {
    	  type: 'step',
          style: {
            stroke: '#d7d7d7'
          }
        }
      }
    };

    chat_tree_config['nodeStructure'] = chat_tree_node.data('tree');
    new Treant(chat_tree_config);
  }

  $(window).on('turbolinks:load', function() {
    initChatTree();
    $('div.wrapper:has(div.chart)').css('margin', '0 50px'); //so adaptive for chart page, sorry I'm backend dev
  });

  function initChatTreeZoom() {
    var zoom_val = localStorage.getItem('chat_tree_zoom');
    if($('#chat-tree-zoom').length && zoom_val) {
      $('#chat-tree-zoom').val(zoom_val);
      $('.chart').css('transform', 'scale(' + zoom_val + ')');
    }
  }



  $(window).on('turbolinks:load', function() {
    // console.log('hello');
    initChatTreeZoom();

    $('.chat-tree-wrapper').on('wheel', function (e) {
      e.preventDefault();
      return false;
    });

    // zoom
    $(document).on('input', '#chat-tree-zoom', function () {
      var zoom_val = parseFloat($(this).val());
      $('.chart').css('transform', 'scale(' + zoom_val + ')');
      // save to ls
      localStorage.setItem('chat_tree_zoom', zoom_val);
    });

    $('.chart').bind('mousewheel', function (e) {
      e.preventDefault();
      e.stopPropagation();
      var zoom_val = parseFloat($('#chat-tree-zoom').val());
      var mouseX = e.pageX;
      var mouseY = e.pageY;
      $('.chart').css('transform-origin', (mouseX) + 'px ' + (mouseY) + 'px ');

      if (e.originalEvent.wheelDelta / 120 > 0) {                               // conventional scroll size: 120 for scroll up, -120 for scroll down
        if (zoom_val < 1.3) {                                                   // 1.3 (130%) from start tree size - maximum value of tree scale to be comfort
          zoom_val += 0.1;                                                      // 0.1 (10%) - step for changing scale
        }
        $('.chart').css('transform', 'scale(' + zoom_val + ')');
      } else {
        if (zoom_val > 0.4) {                                                   // 0.4 (40%) from start tree size - minimum value of tree scale to be comfort
          zoom_val -= 0.1;
        }
        $('.chart').css('transform', 'scale(' + zoom_val + ')');
      }

      $('#chat-tree-zoom').val(zoom_val);
      // save to ls
      localStorage.setItem('chat_tree_zoom', zoom_val)
    });
  });

  // drag scrolling
  $(window).on('turbolinks:load', function() {
    dragscroll.reset();

    var timeout;
    $(document).on('mousemove', function (e) {
      if (timeout !== undefined) {
        window.clearTimeout(timeout);
      }
      timeout = window.setTimeout(function () {
        // trigger the new event on event.target, so that it can bubble appropriately
        $(e.target).trigger('mousemoveend');
      }, 100);
    });

    var mouseX;
    var mouseY;
    var diffX;
    var diffY;

    $('.node').on('mousedown', function (event) {
      mouseX = event.clientX;
      mouseY = event.clientY;
    });
    $('.node').on('click', function (event) {
      diffX = event.clientX - mouseX;
      diffY = event.clientY - mouseY;
      if (diffX === 0 && diffY === 0) {
        return true
      }
      return false;
    });
  });
// });
