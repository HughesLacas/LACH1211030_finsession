package {
	import flash.display.MovieClip;
	import flash.events.*;
	public class Info extends MovieClip {

		public function Info() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e: Event): void {
			indice_mc.visible = false; // on cache les indice
			addEventListener(Event.ENTER_FRAME, loop);
			Main(parent.parent.parent).addEventListener("reset", reset);
		}
		// fonction permet l'animation
		private function loop(e: Event): void {
			indice_mc.visible = false;// on cache les indice

			if (Trump(Principal(parent.parent).nouvTrump.getChildAt(0)).mort == false) { //si trump n'est pas mort
				if (MovieClip(parent.parent).nouvTrump != null) { // entre dans les colision si le clip n'est pas null
					if (Trump(Principal(parent.parent).nouvTrump.getChildAt(0)).hitTestObject(this.sowIndice_mc)) { // effectu les hitTest pour être sur que la cible n'embarque pas sur l'objet
						afficher(); // active la fonction 

					}
				}
				if (MovieClip(parent.parent).paysActuel == "USA") { // si le pays actiel est USA il affiche ces incide
					indice_mc.pays_mc.text = "aux États-Unis!!";
					// il affiche les indice selon le tableau (aléatoirement)
					indice_mc.premier_mc.text = MovieClip(parent.parent).enigmeOfficielUn[0];
					indice_mc.second_mc.text = MovieClip(parent.parent).enigmeOfficielUn[1];
					indice_mc.dernier_mc.text = MovieClip(parent.parent).enigmeOfficielUn[2];

				} else if (MovieClip(parent.parent).paysActuel == "France") { // si le pays est france il affiche ces indice
					indice_mc.pays_mc.text = "en France!!";
					// il affiche les indice selon le tableau (aléatoirement)
					indice_mc.premier_mc.text = MovieClip(parent.parent).enigmeOfficielDeux[0];
					indice_mc.second_mc.text = MovieClip(parent.parent).enigmeOfficielDeux[1];
					indice_mc.dernier_mc.text = MovieClip(parent.parent).enigmeOfficielDeux[2];
				}
			}
		}// sert a afficher les indice
		public function afficher(): void {
			indice_mc.visible = true; //  affiche les indices
		}
		private function reset(e:Event): void {
			//removeEventListener(Event.ENTER_FRAME, loop);
			addEventListener(Event.ADDED_TO_STAGE, init);
		}


	} //class

} //package