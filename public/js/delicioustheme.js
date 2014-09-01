    function validateEmail(email) {
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        return re.test(email);
    }
    function postContactToGoogle(){


        var name = $('#namefield').val();
        var email = $('#mailfield').val();
        var feed = $('#feedtext1').val() + ';' + $('#feedtext2').val() + ';' + $('#feedtext3').val() + ';' + $('#feedtext4').val() + ';' + $('#feedtext5').val();
        //$j('#feed').val();
        //if ((name !== "") && (email !== "") && (validateEmail(email))) {

            $.ajax({
                url: "https://docs.google.com/a/admineo.de/forms/d/1UZEnGheQ1-kIhJq9lFD5nHPr6Cj4gNRXErO7Nz1doWk/formResponse",
                data: {"entry.1292675161" : name, "entry.758192609" : email, "entry.1171404754": feed},
                type: "POST",
                dataType: "xml",
                statusCode: {
                    0: function (){
                        $(".fa-form-wait").css('display', 'none');
						$("#formSubmitMessage").slideDown();
						$("#sendmail").slideUp();
						$(".hideaftersubmit").hide();
						$(".showaftersubmit").slideDown();
						$("#twittertext").attr('href',"http://twitter.com/share?text=Mit+%23meinBGE+würde+ich+" + encodeURIComponent(feed + " - Und du?"));
                    }
                }
            });
        //}
        //else {
            //Error message
        //}
        return false;
    }


$(document).ready(function(){


	var isOpera = !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;
    // Opera 8.0+ (UA detection to detect Blink/v8-powered Opera)
	var isFirefox = typeof InstallTrigger !== 'undefined';   // Firefox 1.0+
	var isSafari = Object.prototype.toString.call(window.HTMLElement).indexOf('Constructor') > 0;
	    // At least Safari 3+: "[object HTMLElementConstructor]"
	var isChrome = !!window.chrome && !isOpera;              // Chrome 1+
	var isIE = /*@cc_on!@*/false || !!document.documentMode; // At least IE6


	if(isChrome) {
		$('.crowdbar_for_chrome').show();
	}
	if(isFirefox) {
		$('.crowdbar_for_ff').show();
	}
	if(!isFirefox && !isChrome) {
		$('.crowdbar_for_others').show();
	}


	$('.morerow .btnstyle').click(function() {
		morerow = $(this).parent().parent();
		morerow.hide();

		morerow.next('.moreformrow').show();
		morerow.next('.moreformrow').next('.morerow').show();
	});


	var top = $("#topContainer");
	//var getApp = $("#getappContainer").offset().top;
	var contentWrapper = $("#contentWrapper");
	var naviWrap = $("#navigationWrap");
	var windowH = $(window);
	var headerHeight = 0;
	var folMenu = $("#followMenu");
	var revWrap = $(".revWrap");
	var revContain = $("#reviewContainer");
	var resMenuToggle = $("#responsiveMenuToggle");

	//generate responsive menu
	$( ".mainMenu" ).clone().prependTo( "#followMenu" );

	var lastId,
	    topMenu = $("#followMenu .mainMenu"),
	    topMenuHeight = 76,
	    // All list items
	    menuItems = topMenu.find("a"),
	    // Anchors corresponding to menu items
	    scrollItems = menuItems.map(function(){
	      var item = $($(this).attr("href"));
	      if (item.length) { return item; }
	    });

	//init style of header
	window.setTimeout(initDelicious, 1000);

	/**
	 *
	 * scroll funciton
	 *
	 */
	$(window).scroll(function() {
		bgPos = $(window).scrollTop() * 1.2;
		$('.textureBgSection').css('background-position', '0px '+bgPos+'px');


	   // Get container scroll position
	   var fromTop = $(this).scrollTop() + topMenuHeight;

	   // Get id of current scroll item
	   var cur = scrollItems.map(function(){
	     if ($(this).offset().top <= (fromTop+5))
	       return this;
	   });
	   // Get the id of the current element
	   cur = cur[cur.length-1];
	   var id = cur && cur.length ? cur[0].id : "";

	   if (lastId !== id) {
	       lastId = id;
	       // Set/remove active class
	       menuItems
	         .parent().removeClass("menuActive")
	         .end().filter("[href=#"+id+"]").parent().addClass("menuActive");
	   }

		if (headerHeight !== 0 && ($(window).scrollTop()+50) > headerHeight) {
			if (!folMenu.hasClass("fmshown")) {
				folMenu.addClass("fmshown");
				//folMenu.stop().fadeIn(300);
			}

		}
		else {
			if (folMenu.hasClass("fmshown")) {
				folMenu.removeClass("fmshown");
				//folMenu.stop().fadeOut(300);
			}
		}

	});

	$(".mainMenu a, #layerslider a").click(function(e) {
		e.preventDefault();
		var target = $(this).attr("href");
		resMenuToggle.trigger('click');

		//alert();

     $('html,body').animate({
         scrollTop: ($(target).offset().top - topMenuHeight)
    }, 800);
	});

	//reviews section
	var revCount = $('.revWrap').length;
	var naviWrap = $("#revsNavi");

	$(".revWrap").eq(0).addClass("revWrapActive");

	for (var i = 0; i < revCount; i++) {
		var revBullet = document.createElement("span");
		revBullet.className = "revBullet";

		revBullet.onclick = function() {
			if (this.className == "revBullet revBulletActive")
				return;

			var thindex = $("#revsNavi span").index( this );

			var mv = $(".revWrap").eq(0).width();
			$(".revViewport").css({
		        transform: 'translate('+(mv * thindex * (-1))+'px, 0px)',
		        '-webkit-transform' : 'translate('+(mv * thindex * (-1))+'px, 0px)'
		    });

		    $(".revWrapActive").removeClass("revWrapActive");
		    $(".revWrap").eq(thindex).addClass("revWrapActive");

		    $(".revBulletActive").removeClass('revBulletActive');
		    $(".revBullet").eq(thindex).addClass("revBulletActive");
		};

		if (i == 0) {
			revBullet.className = "revBullet revBulletActive";
			naviWrap.append(revBullet);
		}
		else
			naviWrap.append(revBullet);
	}


	//shuffle.js init
	var $grid = $('#screensWrap')

	$grid.shuffle({
	    itemSelector: '.screen-item',
	    speed: 500,
	    columnWidth: 279,
	    gutterWidth: 18
	});

    var $filterOptions = $('.filter-options'),
     $btns = $filterOptions.find('.btn');

    $btns.on('click', function() {

      $('#screensViewportWrap').show();

      $('html,body').animate({
          scrollTop: $('#screensViewportWrap').offset().top - 150
        }, 2000);

      //$(window).scrollTop($('#screenfilters').offset().top);

      var $this = $(this),
          isActive = $this.hasClass( 'active' ),
          group = isActive ? 'blub' : $this.data('group');

      // Hide current label, show current label in title
      if ( !isActive ) {
        $('.filter-options .active').removeClass('active');
      }

      $this.toggleClass('active');

      // Filter elements
      $grid.shuffle( 'shuffle', group );
    });

    $btns = null;

	/**
	 *
	 * screens config
	 *
	 */
	var scrnItem = $("#screensWrap .filtered"),
		arrowRight = $("#screensRightAr"),
		arrowLeft = $("#screensLeftAr"),
		nrOfSlides = 0,
		currSlide = 1;

	if ($(window).width() < 768) {
		nrOfSlides = $("#screensWrap .filtered").length;

		if (scrnItem.length < 1) {
			$(".screensArrows").hide();
		}
		else {
			arrowRight.addClass("screensArrowsActive");
			arrowLeft.removeClass("screensArrowsActive");
		}
	}
	else if ($(window).width() >= 768 && $(window).width() <= 1070) {
		nrOfSlides = Math.ceil(scrnItem.length / 2);

		if (scrnItem.length < 3) {
			$(".screensArrows").hide();
		}
		else {
			arrowRight.addClass("screensArrowsActive");
			arrowLeft.removeClass("screensArrowsActive");
		}
	}
	else {
		nrOfSlides = Math.ceil(scrnItem.length / 4);

		if (scrnItem.length < 5) {
			$(".screensArrows").hide();
		}
		else {
			arrowRight.addClass("screensArrowsActive");
			arrowLeft.removeClass("screensArrowsActive");
		}
	}

	arrowRight.click(function() {
		if (!arrowRight.hasClass("screensArrowsActive"))
			return;

		var currentWitdh = $("#screensOfHide").width()+18;
		$("#screensWrapOuter").css({
	        transform: 'translate(-'+((currentWitdh*currSlide))+'px, 0px)',
	        '-webkit-transform' : 'translate(-'+((currentWitdh*currSlide))+'px, 0px)'
	    });
	    currSlide++;

	    if (currSlide == nrOfSlides)
	    	arrowRight.removeClass("screensArrowsActive");
		if (!arrowLeft.hasClass("screensArrowsActive"))
			arrowLeft.addClass("screensArrowsActive");
	});

	arrowLeft.click(function() {
		if (!arrowLeft.hasClass("screensArrowsActive"))
			return;

		currSlide--;
		var addPX = 18
		if (currSlide == 1)
			addPX = 0;

		var currentWitdh = $("#screensOfHide").width();
		$("#screensWrapOuter").css({
	        transform: 'translate(-'+((currentWitdh*(currSlide-1))+addPX)+'px, 0px)',
	        '-webkit-transform' : 'translate(-'+((currentWitdh*(currSlide-1))+addPX)+'px, 0px)'
	    });

	    if (currSlide == 1)
	    	arrowLeft.removeClass("screensArrowsActive");
		if (!arrowRight.hasClass("screensArrowsActive"))
			arrowRight.addClass("screensArrowsActive");
	});


	/**
	 *
	 * reconfigure screens on filter
	 *
	 */
	$grid.on('filter.shuffle', function() {

	    //arrowLeft.removeClass("screensArrowsActive");

	});

	$grid.on('filtered.shuffle', function() {
	    currSlide = 1;

		$("#screensWrapOuter").css({
	        transform: 'translate(0px, 0px)',
	        '-webkit-transform' : 'translate(0px, 0px)'
	    });

		scrnItem = $("#screensWrap .filtered");
		if ($(window).width() < 768) {
			nrOfSlides = scrnItem.length;

			if (scrnItem.length < 1) {
				arrowRight.removeClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
			else {
				$(".screensArrows").show();
				arrowRight.addClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
		}
		else if ($(window).width() >= 768 && $(window).width() <= 1070) {
			nrOfSlides = Math.ceil(scrnItem.length / 2);

			if (scrnItem.length < 3) {
				arrowRight.removeClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
			else {
				$(".screensArrows").show();
				arrowRight.addClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
		}
		else {
			nrOfSlides = Math.ceil(scrnItem.length / 4);
			console.log(scrnItem.length);
			if (scrnItem.length < 5) {
				//$(".screensArrows").hide();
				arrowRight.removeClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
			else {
				$(".screensArrows").show();
				arrowRight.addClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
		}
	});

	/**
	 * responsive menu show on click
	 *
	 */
	resMenuToggle.click(function(){
		if (!folMenu.hasClass("fmToggled")) {
			folMenu.addClass("fmToggled");
			//folMenu.stop().fadeIn(300);
		} else if (folMenu.hasClass("fmToggled")) {
			folMenu.removeClass("fmToggled");
			//folMenu.stop().fadeOut(300);
		}
	});

	/**
	 *
	 * change styles on resize
	 *
	 */
	function resizedw() {
		initDelicious();

		$(".revViewport").css({
	        transform: 'translate(0px, 0px)',
	        '-webkit-transform' : 'translate(0px, 0px)'
	    });

	    $(".revBulletActive").removeClass('revBulletActive');
	    $(".revBullet").eq(0).addClass("revBullet revBulletActive");
	    $(".revWrapActive").removeClass("revWrapActive");
	    $(".revWrap").eq(0).addClass("revWrapActive");

		//screens resizer
		scrnItem = $("#screensWrap .filtered");
		currSlide = 1;
		if ($(window).width() < 768) {
			nrOfSlides = scrnItem.length;

			if (scrnItem.length < 1) {
				$(".screensArrows").hide();
			}
			else {
				$(".screensArrows").show();
				arrowRight.addClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
		}
		else if ($(window).width() >= 768 && $(window).width() <= 1070) {
			nrOfSlides = Math.ceil(scrnItem.length / 2);

			if (scrnItem.length < 3) {
				$(".screensArrows").hide();
			}
			else {
				$(".screensArrows").show();
				arrowRight.addClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
		}
		else {
			nrOfSlides = Math.ceil(scrnItem.length / 4);

			if (scrnItem.length < 5) {
				$(".screensArrows").hide();
			}
			else {
				$(".screensArrows").show();
				arrowRight.addClass("screensArrowsActive");
				arrowLeft.removeClass("screensArrowsActive");
			}
		}

		$("#screensWrapOuter").css({
	        transform: 'translate(0px, 0px)',
	        '-webkit-transform' : 'translate(0px, 0px)'
	    });
	};

	var doit;
	window.onresize = function(){
	  clearTimeout(doit);
	  doit = setTimeout(resizedw, 300);
	};

	/**
	 *
	 * set header slider dimensions and stuff
	 *
	 */
	function initDelicious() {
		headerHeight = top.height();
		contentWrapper.css('top', headerHeight);
		revWrap.css('max-width', revWrap.parent().parent().width());

		//adjust on small screens
		if ((headerHeight-100) > $(window).height())
			top.css('position', 'absolute');
		else
			top.css('position', 'fixed');
	}

	/**
	 *
	 * contact form submit
	 *
	 */
	$( "#sendmail" ).on( "submit", function( event ) {
		event.preventDefault();
		$(".fa-form-wait").css('display', 'inline-block');

		$.ajax( {
			type: "POST",
			url: $( "#sendmail" ).attr( 'action' ),
			data: $( "#sendmail" ).serialize(),
			success: function( response ) {
				var rpl = JSON.parse(response);

				$(".fa-form-wait").css('display', 'none');

				if (rpl.type == "error")
					$("#formSubmitMessage").html('<span style="color: #AA0000;"><i class="fa fa-exclamation-circle"></i> ' + rpl.text + '</span>');
				else {
					$("#formSubmitMessage").html('<span style="color: #40A6A6;"><i class="fa fa-check-circle"></i> ' + rpl.text + '</span>');
					$("#sendmail").slideUp();
				}
			}
		});
	});
});


function isElementInViewport (el) {

    //special bonus for those using jQuery
    if (el instanceof jQuery) {
        el = el[0];
    }

    var rect = el.getBoundingClientRect();
    //console.log(rect.top)
    return (
        rect.top == 0
    );
}