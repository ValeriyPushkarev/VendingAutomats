
    function updateLevels(sender)
    {
        var obj = {};

        var id = $(sender).attr("clientid");
        var moduleName = $(sender).attr("modulename");

        var MinLevel = $("#MinLevel[clientId='"+id+"'][moduleName='"+moduleName+"']").val();
        var MaxLevel = $("#MaxLevel[clientId='"+id+"'][moduleName='"+moduleName+"']").val();

        obj.MinLevel = MinLevel;
        obj.MaxLevel = MaxLevel;

        obj.ClientId = id;
        obj.ModuleName = moduleName;

        jQuery.post('/Modules/Params', obj);
    }

function updateDateTime(sender)
{
    var obj = {};

    var id = $(sender).attr("clientid");
    var moduleName = $(sender).attr("modulename");

    var dateFrom = $("#DateFrom"+moduleName+id+"[clientId='"+id+"'][moduleName='"+moduleName+"']").val();
    var dateTo = $("#DateTo"+moduleName+id+"[clientId='"+id+"'][moduleName='"+moduleName+"']").val();

    var timeFrom = $("#TimeFrom[clientId='"+id+"'][moduleName='"+moduleName+"']").val();
    var timeTo = $("#TimeTo[clientId='"+id+"'][moduleName='"+moduleName+"']").val();

    obj.ClientId = id;
    obj.ModuleName = moduleName;

    obj.DateFrom = dateFrom;
    obj.DateTo = dateTo;
    obj.TimeFrom = timeFrom;
    obj.TimeTo = timeTo;

    jQuery.post('/Modules/Levels', obj,
        function(data)
        {
            var z = data;

            var points =[]
            var labels =[]

            z.forEach(function(item, i, arr)
            {
                points[i] = item.Value;
                labels[i] = item.Date;

            });

            var datad = {
                labels: labels,
                datasets: [
                    {
                        label: "My First dataset",
                        fillColor: "rgba(0,0,220,0.2)",
                        strokeColor: "rgba(0,0,220,1)",
                        pointColor: "rgba(0,0,220,1)",
                        pointStrokeColor: "#fff",
                        pointHighlightFill: "#fff",
                        pointHighlightStroke: "rgba(220,220,220,1)",
                        data: points
                    }],

            };
            // Get the context of the canvas element we want to select
            var ctx = document.getElementById("myChart"+id+moduleName).getContext("2d");
            var chart = $(window).attr("Chart"+id+moduleName);
            if (!(typeof chart == typeof undefined || chart == false))
                chart.destroy();

                $(window).attr("Chart"+id+moduleName, new Chart(ctx).Line(datad, {
                bezierCurve: false,
                tooltipTemplate: "<%if (label){%><%}%><%= value %>",
                pointHitDetectionRadius: 5,
            }));
        })
    .fail(function (jqxhr, textStatus, error) {
        var err = textStatus + ", " + error;
        alert("Request Failed: " + err);
    });
}

       jQuery(document).ready(function () {
           var z = $('.tabs');
           
           $(function () 
           {
               z.tabs();
           });

           $(function () {
               $(".tabs").dialog({
                   autoOpen: false,
                   height: 520,
                   width: 460,
                   modal: true
               });
               });


           jQuery('.clockpicker').clockpicker({
               placement: 'bottom',
               align: 'left',
               donetext: 'Done'
           });

           var isIE = 0 < $('html.old-ie').length;

           $.datepicker.setDefaults({
               changeMonth: true,
               changeYear: true,
               showAnim: "fadeIn",
               yearRange: 'c-30:c+30',
               showButtonPanel: true,
               /* fix buggy IE focus functionality */
               fixFocusIE: false,

               /* blur needed to correctly handle placeholder text */
               onSelect: function (dateText, inst) {
                   this.fixFocusIE = true;
               },

               onClose: function (dateText, inst) {
                   this.fixFocusIE = true;
               },

               beforeShow: function (input, inst) {
                   var result = isIE ? !this.fixFocusIE : true;
                   this.fixFocusIE = false;
                   return result;
               }
           });

           jQuery('.datepicker').datepicker(
                   { dateFormat: "dd.mm.yy" },
                    $.datepicker.regional['ru'] = {
                        closeText: 'Закрыть',
                        prevText: 'Пред',
                        nextText: 'След',
                        currentText: 'Сегодня',
                        monthNames: ['Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь',
                        'Июль', 'Август', 'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'],
                        monthNamesShort: ['Янв', 'Фев', 'Мар', 'Апр', 'Май', 'Июн',
                        'Июл', 'Авг', 'Сен', 'Окт', 'Ноя', 'Дек'],
                        dayNames: ['воскресенье', 'понедельник', 'вторник', 'среда', 'четверг', 'пятница', 'суббота'],
                        dayNamesShort: ['вск', 'пнд', 'втр', 'срд', 'чтв', 'птн', 'сбт'],
                        dayNamesMin: ['Вс', 'Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб'],
                        weekHeader: 'Не',
                        dateFormat: 'dd.mm.yy',
                        firstDay: 1,
                        isRTL: false,
                        showMonthAfterYear: false,
                        yearSuffix: ''
                    },
                   $.datepicker.setDefaults($.datepicker.regional['ru'])
               );

          

       });
