import 'adminos/adminos'
import './trix'
import './tree.js'
import './Treant'
import 'treant-js/Treant.js'
import './check_box_all'
import './datetimepicker'

import Raphael from "raphael";
window.Raphael = Raphael

import Dragscroll from "dragscroll";
window.dragscroll = Dragscroll

import Chartkick from "chartkick"
import Chart from "chart.js"
Chartkick.use(Chart);

import Turbolinks from 'turbolinks'
Turbolinks.start();
