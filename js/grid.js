$( function() {

  // count number of authors to populate dropdown
  // and key it so it can be alphabetized by author
  var widget_authors = {};
  $('.widget-author > a').each(function() {
    var cur_author = $(this).html();
    var lcur_author = cur_author.toLowerCase();
    if(widget_authors[lcur_author] === undefined)
      widget_authors[lcur_author] = {author: cur_author, count: 0};
    widget_authors[lcur_author].count = widget_authors[lcur_author].count + 1;
  });

  // populate the author filter dropdown
  $.each(Object.keys(widget_authors).sort(), function (i, val) {
    $('#authorfilter').append($('<option/>', {
      value: widget_authors[val].author,
      text : widget_authors[val].author + ' (' + widget_authors[val].count + ')'
    }));
  });

  // count tags to populate dropdown
  // and key it so it can be alphabetized by author
  var widget_tags = {};
  $('.widget-tags').each(function() {
    var cur_tags = $(this).html();
    cur_tags = cur_tags.split(',');
    for (var i = 0; i < cur_tags.length; i++) {
      var cur_tag = cur_tags[i].trim();
      var lcur_tag = cur_tag.toLowerCase();
      if(cur_tag !== '') {
        if(widget_tags[lcur_tag] === undefined)
          widget_tags[lcur_tag] = {tag: cur_tag, count: 0};
        widget_tags[lcur_tag].count = widget_tags[lcur_tag].count + 1;
      }
    }
  });

  // populate the tag filter dropdown
  $.each(Object.keys(widget_tags).sort(), function (i, val) {
    $('#tagfilter').append($('<option/>', {
      value: widget_tags[val].tag,
      text : widget_tags[val].tag + ' (' + widget_tags[val].count + ')'
    }));
  });

  // initialize author and tag select dropdowns
  $('select').material_select();

  var $grid = $('#grid');

  $grid.isotope({
    itemSelector : '.grid-item',
    layoutMode: 'masonry',
    getSortData: {
      // author: '[data-author]',
      author: function( itemElem ) {
        var name = $( itemElem ).find('.widget-author').text();
        return name.toLowerCase();
      },
      name: function( itemElem ) {
        var name = $( itemElem ).find('.card-title').text();
        return name.toLowerCase();
      },
      stars: function( itemElem ) {
        var stars = -parseInt($( itemElem ).find(".gh-count").html());
        // if the package is not on github, return 0
        if (isNaN(stars)) {
          return 0;
        }
        return stars;
      }
    },
    masonry: {
      isFitWidth: true,
      gutter: 20
    }
  });

  // use value of search field to filter
  var $textfilter = $('#textfilter').keyup( debounce( function() {
    $("#crancheckbox").prop('checked', false);
    if(! $("#tagfilter").val() === "") {
      $("#tagfilter").val(0);
      $("#tagfilter").material_select();
    }
    if(! $("#authorfilter").val() === "") {
      $("#authorfilter").val(0);
      $("#authorfilter").material_select();
    }
    handleFilter();
  }, 100 ) );

  // trigger isotope sort on #gridsort change
  $('#gridsort').change(function() {
    var sortVal = $(this).val();
    if(sortVal === 'stars')
      $grid.isotope('updateSortData');
    $grid.isotope({ sortBy : sortVal });
  });

  // trigger isotope filter on #authorfilter change
  // this resets tag and text filters and unchecks CRAN, as the
  // number in the dropdown is for all packages by this author
  $('#authorfilter').change(function() {
    $("#tagfilter").val(0);
    $("#tagfilter").material_select();
    $("#textfilter").val("");
    $("#crancheckbox").prop('checked', false);
    handleFilter();
  });

  // trigger isotope filter on #tagfilter change
  // this resets author and text filters and unchecks CRAN, as the
  // number in the dropdown is for all packages by this author
  $('#tagfilter').change(function() {
    $("#authorfilter").val(0);
    $("#authorfilter").material_select();
    $("#textfilter").val("");
    $("#crancheckbox").prop('checked', false);
    handleFilter();
  });

  // trigger isotope filter on #crancheckbox change
  $("#crancheckbox").click(function() {
    handleFilter();
  });

  // look at all filter inputs and determine which ones to show
  function handleFilter() {
    var tagVal = $('#tagfilter').val();
    var authorVal = $('#authorfilter').val();
    var textVal = $('#textfilter').val();
    var qsRegex;

    console.log("tagVal: " + tagVal);
    console.log("authorVal: " + authorVal);
    console.log("textVal: " + textVal);
    console.log("qsRegex: " + qsRegex);

    $grid.isotope({ filter : function() {
      var textBool = true;
      if(textVal !== '') {
        qsRegex = new RegExp( textVal, 'gi' );
        curText = $(this).find('.card-title').html() + " " + $(this).find('.widget-author > a').html() + " " + $(this).find('.widget-shortdesc').html();
        textBool = qsRegex.test(curText);
      }

      var tagBool = true;
      if(! (tagVal === '' || tagVal === null)) {
        tagBool = false;
        var tags = $(this).find('.widget-tags').html();
        tags = tags.split(',');
        for (var i = 0; i < tags.length; i++) {
          tagBool = tagBool || (tags[i] == tagVal);
        }
      }

      var authorBool = true;
      if(! (authorVal === '' || authorVal === null)) {
        authorBool = false;
        authorBool = $(this).find('.widget-author > a').html() == authorVal;
      }

      var cranBool = $(this).find('.widget-cran').html() === "true";
      if($("#crancheckbox:checked").length === 0) {
        cranBool = true;
      }

      var res = textBool && tagBool && authorBool && cranBool;
      if(res) {
        $(this).addClass('is-showing');
      } else {
        $(this).removeClass('is-showing');
      }
      return res;
    }});
    $("#shown-widgets").html($('.is-showing').length);
  }

  // wrap hrefs around the tag listings for each widget
  // so when clicked they can fire off a filter on that tag
  $('.widget-tags').each(function(i) {
    var tagVals = $(this).html().split(',');
    $(this).addClass('hidden');
    for (var j = 0; j < tagVals.length; j++) {
      var el = document.createElement("a");
      el.className = 'taghref';
      el.textContent = tagVals[j];
      el.href = 'javascript:;';
      $(this).before(el);
      if (j < tagVals.length - 1) {
        $(this).before(", ");
      }
    }
  });

  // handle click on tag hrefs
  $('.taghref').click(function() {
    $('#tagfilter > option').removeAttr("selected");
    $('#tagfilter > option[value="' + $(this).html() + '"]').attr("selected", "selected");
    $('select').material_select();
    $('#tagfilter').trigger('change');
  });

  $.getJSON( "github_meta.json", function(data) {
    $.each(data, function(key, val) {
      $('#' + key).html(val.stargazers_count);
    });
  })
  .success(function() {
    // default sort is by github stars - trigger it on load
    $('#gridsort').trigger('change');
  });

  // enforce initial filter (CRAN only)
  handleFilter();
  // make sure "Showing x of n" is correct
  var curlen = $(".widget-cran").filter(function() {return $(this).html() === "true"}).length;
  $("#shown-widgets").html(curlen);
});

function debounce( fn, threshold ) {
  var timeout;
  return function debounced() {
    if ( timeout ) {
      clearTimeout( timeout );
    }
    function delayed() {
      fn();
      timeout = null;
    }
    timeout = setTimeout( delayed, threshold || 100 );
  };
}



// var $grid = $('.grid').isotope({
//   itemSelector: '.grid-item',
//   isFitWidth: true
//   // percentPosition: true,
//   // masonry: {
//   //   // use element for option
//   //   columnWidth: '.grid-item',
//   //   rowHeight: '.grid-item'
//   // }
// });

