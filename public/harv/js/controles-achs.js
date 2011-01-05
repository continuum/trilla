/*
 * Eventos de Controles ACHS
 * Desarrollado por ContinuumChile
 *
 */
(function ($) {

	var TIME_FADE_OUT_IN = 500;
	var IE6 = false; 
	
	if (($.browser.msie) && (Number($.browser.version) == 6))
		IE6 = true;
		
	
	
	window.formatDateString = function(d){
		 function pad(n){
			 return n < 10 ? '0' + n : n
		 }
		 return pad(d.getUTCDate()) + " de " + pad(d.getUTCMonth()) + " del " + d.getUTCFullYear()
	}

	// jquery plugins
	$.fn.tabACHS = function(settings) {
		return this.each(function () {
			var _lis = $(this).children("ul").children("li"); // todos los li
			var _this = this; // salva this
			// on click de cada li
			_lis.click(function () {
	      _lis.removeClass("tab-select").removeClass("sinseparador").addClass("tab-unselect");
				$(this).removeClass("tab-unselect").addClass("tab-select").next().addClass("sinseparador");
			});
		});
	}

  $(document).ready(function () {
    //Pestanhas
  	$(".component-navigator-tabs").tabACHS();
  	
  	
  		//tooltip
  	$.fn.tooltip = function(message) {
		$(this).each(function(){
			if (typeof(message) != 'undefined') {
				$(this).find('.toolTips').remove();
				$(this).append('<div class="toolTips">' + message + '</div>');
			} else {
				var  mc = $(this).find('.toolTips');
				if (mc.size() == 0)
					return alert('Debe agregar un elemento con la clase toolTips al elemento.');
			}
			$(this).mouseover(
				function(event){
					$(this).find('.toolTips').showMouseOverModal(event);
				}
			);
			$(this).unbind('mouseout').mouseout(
				function(event){
					$(this).find('.toolTips').hideMouseOutModalWindow();
						}
			);
		});
  	
  	};
  	
  	
  	
  	// modal
  	
  	$.fn.putCloseButton = function(tiempoFadeInOut){
  		tiempoFadeInOut = tiempoFadeInOut ? tiempoFadeInOut : TIME_FADE_OUT_IN;
  		var thisFn = $(this);
  		thisFn.append('<a href="javascript:void(0)" class="btn-cerrar ui-dialog-titlebar-close">Cerrar</a>');
  		thisFn.find('.btn-cerrar').hideModalWindow(thisFn, tiempoFadeInOut);
  		thisFn.find('.cancel-btn').hideModalWindow(thisFn, tiempoFadeInOut);
  		
  		var firstChildBody = $($('body :first-child')[0]);
  		if ($('.ui-widget-overlay').length == 0) {
  			var bodyHeight = Math.max($('body').height(), screen.height);
  			firstChildBody.before('<div class="ui-widget-overlay" style="display: none;width: 100%; height: ' + bodyHeight + 'px;"></div>');
  		}
  		
  	};
  
  	$.fn.hideModalWindow = function(thisFn, tiempoFadeInOut){
  		$(this).unbind('click').click(function(event){
  			thisFn.fadeOut(tiempoFadeInOut, function(){
  				thisFn.hide();
			});
  			$('.ui-widget-overlay').hide();
  			$('body').css('overflow', 'auto');
//  			$('.ui-widget-overlay').fadeOut(tiempoFadeInOut, function(){
//  			});
  			if (IE6) {
  				$('select').show();
  				$('input').show();
  				$('textarea').show();
  			}
		});
  	};
  	
  	$.fn.showMouseOverModal = function(event, tiempoFadeInOut){
  		var thisFn = $(this);
  		tiempoFadeInOut = tiempoFadeInOut ? tiempoFadeInOut : TIME_FADE_OUT_IN;
  		thisFn.css('left', event.pageX).css('top', event.pageY + 20);
  		thisFn.fadeIn(tiempoFadeInOut, function(){
			//thisFn.show();
			thisFn.bgiframe();
		});
  	};
  	
  	$.fn.hideMouseOutModalWindow = function(thisFn, tiempoFadeInOut) {
		var thisFn = $(this);
  		tiempoFadeInOut = tiempoFadeInOut ? tiempoFadeInOut : TIME_FADE_OUT_IN;
  		thisFn.fadeOut(tiempoFadeInOut, function(){
  			thisFn.hide();
  		});
  	};
  	
  	$.fn.showModalWindow = function(tiempoFadeInOut){
  		var thisFn = $(this);
  		tiempoFadeInOut = tiempoFadeInOut ? tiempoFadeInOut : TIME_FADE_OUT_IN;
  		thisFn.fadeIn(tiempoFadeInOut, function(){
  			//thisFn.show();
  			thisFn.bgiframe();
		});
			if (IE6) {
  				$('select').hide();
  				$('input').hide();
  				$('textarea').hide();
  			}
  		$('.ui-widget-overlay').show();
  		$('body').css('overflow', 'hidden');
  	};
  	
  	$.fn.showGlobeWindow = function(event, tiempoFadeInOut){
  		var thisFn = $(this);
  		tiempoFadeInOut = tiempoFadeInOut ? tiempoFadeInOut : TIME_FADE_OUT_IN;
  		thisFn.css('left', event.pageX).css('top', event.pageY + 20);
  		thisFn.fadeIn(tiempoFadeInOut, function(){
  			thisFn.show();
		});
  	};
  	
    // calendar
	  $.datepicker.setDefaults($.datepicker.regional['es']);

	  var calendar_settings = {
		  	firstDay: 1,
		  	changeMonth: true,
		  	changeYear: true,
		  	showButtonPanel: true,
		  	gotoCurrent: true,
		  	beforeShow: function (input, instance) {
	  	    //var _html = $(instance.dpDiv).children(".ui-datepicker-buttonpane");
	  	    //var inner_html = 'Hoy es: '+ formatDateString(new Date());
	  		}
		};
	  
	  var posicionarCalendario = function(componente) {
		  if(document.body.clientWidth <= 1280) {
			  $('#ui-datepicker-div').css('left', componente.offset().left - 100);
		  }
	  }
	  
	  $('.boxCalendar').datepicker(calendar_settings).click(function() {
		  posicionarCalendario($(this).parent());
	  });
	  
	  $(".popCalendar").click(function () {
		  $(this).parent().children('.boxCalendar').datepicker(calendar_settings).datepicker('show');
		  posicionarCalendario($(this).parent());
	  });

    //Botones
    $("button").hover(
      function () {
        $(this).children("div").addClass("over").children().addClass("over")
      },
      function() {
        $(this).children("div").removeClass("over").children().removeClass("over")
      }
      ).mousedown(function () {
        $(this).children("div").addClass("press").children().addClass("press")
      }).mouseup(function () {
        $(this).children("div").removeClass("press").children().removeClass("press")
      });
    
    $('.withClose').putCloseButton();

    //Draggable 
    $(".draggableTable").tableDnD({ 
    	onDrop: function onDropRow(table, row) {
            var rowJq = $(row);
            var tableJq = $(table);
            var tds = rowJq.find('td');
            if (tds.hasClass('rowDragHover'))
            	tds.removeClass('rowDragHover');
            tds.addClass('rowDragNormal');
    	},
        onDragStart:function onDragRowStart(table, row){
    		var rowJq = $(row);
			var tableJq = $(table);
    		var tds = rowJq.find('td');
    		if (tds.hasClass('rowDragNormal'))
    			tds.removeClass('rowDragNormal');
    		tds.addClass('rowDragHover');
			tableJq.addClass('blockTooltip');
    	}, classHoverExt: 'cursorDrag'});
    });
    
   //Draggable Table (out)
   $('.content-table-data-drag div').each(function(i, elemento){
                $(elemento).draggable({
                    revert: 'invalid', 
                    helper: 'clone',
                    cursor: 'pointer',
                    opacity: 0.7,
                    zIndex: 30000
               });
				
    });
	
	//Dropable Content
		function initDropable(){

			$('.content-table-data-drop').droppable({
                accept: '.draggable_element',
                activeClass: 'drop_hover',
                hoverClass: 'drop_hover',
                drop: onDropElement
			});
	
            $.fn.incrementar = function(){
                $(this).html(parseInt($(this).html()) + 1);
            };
            
            $.fn.decrementar = function(){
                $(this).html(parseInt($(this).html()) - 1);
            };
            
            $('#a-include-all-first').unbind('click').click(function(){
                $('#first-content div').each(function(i, firstHtml){
                    var firstElement = $(firstHtml);
                    if ($('.content-table-data-drop').find('#' + firstElement.attr('id')).length == 0) 
                        putElementsIntoDropContainer(firstElement, $('.content-table-data-drop'))
                });
            });
            
            $('#a-include-all-second').unbind('click').click(function(){
                $('#second-content div').each(function(i, secondtHtml){
                    var secondElement = $(secondtHtml);
                    if ($('.content-table-data-drop').find('#' + secondElement.attr('id')).length == 0) 
                        putElementsIntoDropContainer(secondElement, $('.content-table-data-drop'))
                });
            });
        }
    
              
        function putElementsIntoDropContainer(elementoOriginal, thisObj, helper){
			
            if (elementoOriginal.css('display') == 'none') 
                return false;
            var elementoClonado = elementoOriginal.clone(false);
            var tipoElemento = elementoClonado.find('.tipo').val();
           
            var dropElement = function(){
				
				elementoOriginal.draggable("option", "disabled", true);	
                                
                if (thisObj) 
                    thisObj.find('h4').show();
                
                var enlaceElementoClonado = elementoClonado.find('a');
                enlaceElementoClonado.html('Quitar');
                enlaceElementoClonado.unbind('click').click(quitarElementoEvent);
                enlaceElementoClonado.attr('id', 'quitar-' + elementoOriginal.attr('id'));
                
                elementoClonado.addClass('dropped');
                elementoOriginal.find('a').unbind('click');
                if (helper) 
                    helper.remove();
                
				
                if (thisObj && thisObj.parent().hasClass('empty')) {
                    thisObj.parent().removeClass('empty');

                }
                return true;
            };
             
            if (tipoElemento == "A") {
                elementoClonado.insertBefore('#h4-grupob-titulo');
                $('#span-count-first').incrementar();
            } else {
				elementoClonado.insertAfter('#h4-grupob-titulo');
                $('#span-count-second').incrementar();
                elementoClonado.find('tr').append('<td class="links"><a href="javascript:void(0)"></a></td>');
            }

            return dropElement();			
        }
        
        function onDropElement(event, ui){
            putElementsIntoDropContainer(ui.draggable, $(this), ui.helper);
        }
                
        function quitarElemento(id){
            var elementoAEliminar = $('.content-table-data-drop').find('#' + id);
            var tipoElemento = elementoAEliminar.find('.tipo').val();
            
            var containerElementSelector = (tipoElemento == "A") ? '#first-content div' : '#second-content div';
            var countElementSelector = (tipoElemento == "A") ? '#span-count-first' : '#span-count-second';
            var containerElementSelectorJq = $(containerElementSelector);
            var elementWasNotRemoved = true;
            var checkEmptyGroupsContainer = function(){
                if (parseInt($('#span-count-first').html()) == 0 &&
                        parseInt($('#span-count-second').html()) == 0) {
                    $('.content-table-data-drop').parent().addClass('empty');
                    $('.content-table-data-drop h4').hide();

                }
            };

            var removeElement = function(){
                elementoAEliminar.remove();
                $(countElementSelector).decrementar();

            };
            
            containerElementSelectorJq.each(function(i, elemento){
                var elementoJquery = $(elemento);
                if (elementoAEliminar.attr('id') == elementoJquery.attr('id')) {
                    enableElement(elementoJquery);
                    removeElement();
                    elementWasNotRemoved = false;
                    return elementWasNotRemoved;
                }
            });
            
            if (elementWasNotRemoved) 
                removeElement();
            checkEmptyGroupsContainer();
        }
        
		function formatId(event){
			return $(event.currentTarget).attr('id').toString().replace(/.*-([0-9_]+)$/, '$1');
		}

        function quitarElementoEvent(event){
            quitarElemento(formatId(event));
        }
        
        
        function enableElement(element){
            element.draggable("option", "disabled", false);
        }
        
		initDropable();

})(jQuery);
