//==============================================
//  add courtesy accidentals v1.0
//
//  Copyright (C)2022 Somé Tsao
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//==============================================

import QtQuick 2.0
import QtQuick.Dialogs 1.2
import MuseScore 3.0

MuseScore {
      menuPath: "Plugins.modernAccidentals"
      description: "This plugin adds an accidental to every note that has one except for natural. Doesn't remove natural accidentals if they are present."
      version: "1.0"

      // if nothing is selected process whole score
      property bool processAll: false

      MessageDialog {
            id: versionError
            visible: false
            title: "Unsupported MuseScore Version"
            text: "This plugin needs MuseScore v3.0.5 or higher"
            onAccepted: { Qt.quit() }
      }
      // function accidentalType
      // takes a note object, depending on the TPC
      // returns an accidental type based on it 
      function accidentalType(noteObject){
            var tpc = noteObject.tpc
            if(tpc >=-1 && tpc <=5){
                  return Accidental.FLAT2
            }
            if(tpc >=6 && tpc <= 12){
                  return Accidental.FLAT
            }
            if(tpc >= 13 && tpc <= 19){
                  return noteObject.accidentalType
            }
            if(tpc >= 20 && tpc <= 26){
                  return Accidental.SHARP
            }
            if(tpc >= 27 && tpc <= 33){
                  return Accidental.SHARP2
            }
            return noteObject.accidentalType
      }

      function addAccidentals(){
            var es=curScore.selection.elements
            for(var i = 0; i < es.length; i++){
                  if(es[i].type == Element.NOTE){
                     es[i].accidentalType = accidentalType(es[i])
                  }
            }
      }
      onRun: {
            if(mscoreMajorVersion == 3 && mscoreMinorVersion == 0
            && mscoreUpdateVersion < 5) {
                  versionError.open();
            } else {
                  addAccidentals()
            }
            Qt.quit()
      }
}
