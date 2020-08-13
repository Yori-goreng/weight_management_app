// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require Chart.min
//= require flatpickr
//= require flatpickr/l10n/ja
//= require jquery3
//= require popper
//= require bootstrap-sprockets
//= require turbolinks
//= require_tree .

var chart_weight;
var chart_existence = false;

var today = new Date();
var a_week_ago = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 6);
var two_weeks_ago = new Date(today.getFullYear(), today.getMonth(), today.getDate() - 13);
var a_month_ago = new Date(today.getFullYear(), today.getMonth() - 1, today.getDate());
var three_months_ago = new Date(today.getFullYear(), today.getMonth() - 3, today.getDate());
var a_year_ago = new Date(today.getFullYear() - 1, today.getMonth(), today.getDate());

// カレンダーのフォーム（flatpickr）
// turbolinks:loadで全部読み込みされてから発火
$(document).on('turbolinks:load', function () {
    // 日本語化
    flatpickr.localize(flatpickr.l10ns.ja);

    // グラフ用カレンダー
    if (document.getElementById('start-date')) {
        // ユーザが入力した古い日付のデータを代入
        var start_date = gon.start_date;
        var end_date = gon.end_date;
        // グラフの表示フラグを初期設定する
        chart_existence = false;
        flatpickr('#start-date', {
            disableMobile: true,
            // 選択範囲の指定
            minDate: start_date,
            maxDate: end_date
        });
        flatpickr('#end-date', {
            disableMobile: true,
            minDate: start_date,
            maxDate: end_date
        });
        // グラフの初期表示
        onButtonClickWeek();
    }
});

// 開始日と終了日を引数とした，体重のグラフを描く関数
function drawGraphs(from, to) {
    // 基礎代謝の値を代入
    var basal_metabolism = gon.basal_metabolism;

    // ユーザが指定した期間のデータを取り出す処理
    var graphs = gon.graphs.filter(function (graph) {
        // dateに日付データを全て渡す
        date = new Date(graph.date);
        // fromからtoまでと指定して処理終了
        return from <= date && date <= to;
    });
    var dates_data = graphs.map(function (graph) {
        // 横軸に表示したい書式に加工
        return graph.date.replace(/^\d+-0*(\d+)-0*(\d+)$/, '$1/$2');
    });
    // 縦軸のデータをそれぞれ渡す
    var weights_data = graphs.map(function (graph) {
        return graph.weight;
    });

    var cal_judge_data = graphs.map(function (graph){
        return graph.cal_judge - basal_metabolism;
    });

    var bar_chart_data = {
        labels: dates_data,
        datasets: [{
            label: '体重(kg)',
            type: 'line',
            data: weights_data,
            backgroundColor: 'rgba(254,97,132,0.8)',
            borderColor: 'rgba(254,97,132,0.8)',
            borderWidth: 3,
            spanGaps: true,
            fill: false,
            yAxisID: 'y-axis-1',
        },
        {
            label: 'カロリー(cal)',
            type: 'bar',
            data: cal_judge_data,
            backgroundColor: 'rgba(54,164,235,0.5)',
            borderColor: 'rgba(54,164,235,0.8)',
            borderWidth: 1,
            spanGaps: true,
            yAxisID: 'y-axis-2',
        }]
    };

    console.log(bar_chart_data);

    // グラフが表示されているか確認
    if (chart_existence) {
        //グラフがあるので更新
        chart_weight.data = bar_chart_data;
        //chart_weight.options.tooltips.callbacks = chart_weight_callbacks;
        chart_weight.update();
    } else {
        //グラフがないので作成
        var ctx_weight = document.getElementById('chartWeight').getContext('2d');

        chart_weight = new Chart(ctx_weight, {
          type: 'bar',
          data: bar_chart_data,
          options: {
            scales: {
                yAxes: [{
                    id: 'y-axis-1',   // Y軸のID
                    position: 'left', // どちら側に表示される軸か？
                    ticks: {          // スケール
                        suggestedMax: weights_data[0]+5,
                        suggestedMin: weights_data[0]-5,
                    }
                },
                {
                    id: 'y-axis-2',
                    position: 'right',
                    ticks: {
                        max: 1500,
                        min: -500,
                    },
                    gridLines: {
                        display: false,
                    }
                }]
            }
          }
        });
        // グラフが表示されていなければオブジェクト作成、表示されていれば更新
        chart_existence = true;
    }
}

// 日付フォームに入力する関数
function inputDate(date_id, date) {
    var year = date.getFullYear();
    var month = ("00" + (date.getMonth() + 1)).slice(-2);
    var day = ("00" + date.getDate()).slice(-2);

    document.getElementById(date_id).value = year + '-' + month + '-' + day;
}

// 期間指定のボタン機能
function onButtonClickPeriod() {
    var from = new Date(document.getElementById('start-date').value);
    var to = new Date(document.getElementById('end-date').value);
    // 開始日からの3ヶ月後の日付を取得
    var three_months_later = new Date(from.getFullYear(), from.getMonth() + 3, from.getDate());

    // getTimeで最初の日からどれだけの時間が経過しているかに変換して比較
    if (from.getTime() > to.getTime()) {
        alert('指定期間を正しく入力して下さい。');
    } else if (three_months_later.getTime() < to.getTime()) {
        alert('期間は３ヶ月以内として下さい。');
        // 3ヶ月後までをとりあえず表示
        drawGraphs(from, three_months_later);
    } else {
        drawGraphs(from, to);
    }
}

// 過去◯日間のボタン機能
function onButtonClickPast(from) {
    // 過去◯日前のデータが無い場合は，最も古いデータを開始日とする
    var start_date = new Date(gon.start_date);

    if (start_date.getTime() < from.getTime()) {
        start_date = from;
    }

    drawGraphs(start_date, today);

    inputDate('start-date', start_date);
    inputDate('end-date', today);
}

function onButtonClickWeek() {
    onButtonClickPast(a_week_ago);
}

function onButtonClickTwoWeek() {
    onButtonClickPast(two_weeks_ago);
}

function onButtonClickMonth() {
    onButtonClickPast(a_month_ago);
}

function onButtonClickThreeMonth() {
    onButtonClickPast(three_months_ago);
}