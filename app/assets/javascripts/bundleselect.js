

var clicked_once = false;
var clicked_twice = false;
var beginning_span = null;
var user_cb_spans = [];
var beginning_id = 0;
var ending_id = 0;

function clicked_on_cb_span(cb_span){
return function(){
  //do some resets
  $('cb_add').disabled = true;
  user_cb_spans = [];
  //completed the bundle assignment
  if (clicked_once){
    clicked_once = false;
    if (cb_span == beginning_span){
      cb_span.removeClassName('learnopedia_bundle_element_selected');
    }
    else {
      //find all spans in between this cb_span and beginning_span and "select" those
      clicked_twice = true;
      beginning_id = Math.min(beginning_span.ordinal_cb_id, cb_span.ordinal_cb_id);
      ending_id = Math.max(beginning_span.ordinal_cb_id, cb_span.ordinal_cb_id);

      user_cb_spans = all_cb_spans.slice(beginning_id, ending_id + 1);
      user_cb_spans.each(function(cb_span){cb_span.addClassName('learnopedia_bundle_element_selected');});

      $('cb_add').disabled = false;
    }

  }
  else if (clicked_twice){
        clicked_twice = false;
        $('cb_add').disabled = true;
        user_cb_spans = all_cb_spans.slice(beginning_id, ending_id + 1);
        user_cb_spans.each(function(cb_span){cb_span.removeClassName('learnopedia_bundle_element_selected');});
        
  }

  //beginning the bundle assignment
  else {
    clicked_once = true;
    //highlight this span
    beginning_span = cb_span;
    cb_span.addClassName('learnopedia_bundle_element_selected');
  }
}
}

function add_cb_learnopedia(){
    //package up all cb_id's to send back to the server
    var cb_ids = user_cb_spans.map(function(cb_span){return cb_span.readAttribute('cb_id')});
    $('concept_bundle_cb_ids').value = cb_ids.toJSONString();
    return true;
}