var clicked_once = false;
var clicked_twice = false;
var beginning_span = null;
var user_cb_spans = [];
var beginning_id = 0;
var ending_id = 0;

function clicked_on_cb_span(cb_span){
    return function(){
      //do some resets
      $('#cb_add').attr('disabled', true)
      user_cb_spans = [];
      //completed the bundle assignment
      if (clicked_once){
        clicked_once = false;
        if (cb_span == beginning_span){
          $(cb_span).removeClass('learnopedia_bundle_element_selected');
        }
        else {
          //find all spans in between this cb_span and beginning_span and "select" those
          clicked_twice = true;
          beginning_id = Math.min(beginning_span.ordinal_cb_id, cb_span.ordinal_cb_id);
          ending_id = Math.max(beginning_span.ordinal_cb_id, cb_span.ordinal_cb_id);

          user_cb_spans = $(all_inactive_cb_spans).slice(beginning_id, ending_id + 1);
          $.each(user_cb_spans, function(i, cb_span){$(cb_span).addClass('learnopedia_bundle_element_selected');});

          $('#cb_add').attr('disabled', false)
        }

      }
      else if (clicked_twice){
        clicked_twice = false;
        $('#cb_add').attr('disabled', true)
        user_cb_spans = all_inactive_cb_spans.slice(beginning_id, ending_id + 1);
        $.each(user_cb_spans, function(i, cb_span){$(cb_span).removeClass('learnopedia_bundle_element_selected');});
      }

      //beginning the bundle assignment
      else {
        clicked_once = true;
        //highlight this span
        beginning_span = cb_span;
        $(cb_span).addClass('learnopedia_bundle_element_selected');
      }
    }
}

function add_cb_learnopedia(){
    //package up all cb_id's to send back to the server
    var cb_ids = $.map(user_cb_spans, function(cb_span, i){return $(cb_span).attr('cb_id')});
    $('#concept_bundle_cb_ids').attr('value', JSON.stringify(cb_ids));
    return true;
}

function setup_spans_to_be_added_to_cbs(){
    for (var i = 0; i < all_inactive_cb_spans.length; i++){
        $(all_inactive_cb_spans[i]).bind('click', clicked_on_cb_span(all_inactive_cb_spans[i]));
    }
}

function setup_concept_bundle_hovers_contributor(){
    setup_concept_bundle_hovers(true);
}

function setup_concept_bundle_hovers_student(){
    setup_concept_bundle_hovers(false);
}

function setup_concept_bundle_hovers(contributor){
    for (var i = 0; i < all_active_cb_spans.length; i++){
        var cb_tag = all_active_cb_spans[i];
        var active_num = $(cb_tag).attr('cb_active_tag_num');
        //if they click on a concept bundle, it springs open the window
        $(cb_tag).bind('click', {active_num : active_num}, function(event){
            var video_and_question_window = $('#problem_and_video_window_' + event.data.active_num);
            //toggle on/off
            if (video_and_question_window.html() == ''){
                video_and_question_window.show();
                video_and_question_window.html(spinner);
                $.ajax({
                  url : "/concept_bundle/video_and_question_window/",
                  data : {'id' : video_and_question_window.attr('real_cb_id'), 'contributor' : contributor}
                }).done(function(rendered_html) {
                  video_and_question_window.html(rendered_html);
                });
            }
            else {
                video_and_question_window.html('');
                video_and_question_window.hide();
            }
        });
        //shows them information about the concept bundle
        if (cb_info[active_num]){
            $(cb_tag).bind('mouseover', {active_num : active_num}, function(event){
                $.cursorMessage('&nbsp;&nbsp;&nbsp;' + cb_info[event.data.active_num], {hideTimeout:0});
                setTimeout(function(){$.hideCursorMessage();}, 3000);
            });
        }
    }
}

function scroll_to_concept_bundle(ord_num){
    var concept_bundle_spans = jQuery(".learnopedia_bundle_element_active_" + ord_num).toArray();
    $('html, body').animate({scrollTop: $(concept_bundle_spans[0]).offset().top}, 1000);
}