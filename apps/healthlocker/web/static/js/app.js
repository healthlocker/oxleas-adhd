// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import 'phoenix_html';
import socket from './socket';
import Room from "./room"
import './tracker.js';

var nav = document.getElementById('my-sidenav');

function openNav () {
  nav.style.width = '100%';
}

function closeNav () {
  nav.style.width = '0';
}

document.getElementById('open-nav').addEventListener('click', openNav);
document.getElementById('close-nav').addEventListener('click', closeNav);

var goalCompletion = document.getElementById('goal_completed');
var notes = document.getElementById('notes');
var url = window.location.href;

function displayNotes () {
  if (goalCompletion.checked) {
    notes.classList.remove('dn');
  } else {
    notes.classList.add('dn');
  }
}

if (url.search(/goal/) && goalCompletion) {
  displayNotes();
  goalCompletion.addEventListener('click', displayNotes);
}

Room.init(socket, document.getElementById("message-feed"))

if (document.getElementById("close_tab")) {
  document.getElementById("close_tab").addEventListener('click', function() {window.close()});
}
