package {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	public class Trump extends MovieClip {
		// détermine la vitesse------------
		private var _vitesse: int = 10;
		private var etat: String = "arret";
		
		
		// DIRECTION
		private var _vitDroite: int; // vitesse de direction
		private var _vitGauche: int; // vitesse de direction
		private var _vitHaut: int; // vitesse de direction
		private var _vitBas: int; // vitesse de direction
		private var infranchi: Array; // tableau de tuil qui peux pas franchir
		private var _posX: uint; // position x
		private var _posY: uint; // position y
		private var cpt: int = 0; // QU'IL ARRETE
		
		// son
		private var lose:Sound;
		
		private var _mort: Boolean; // detectrion de vie 
		public function Trump() {
			addEventListener(Event.ADDED_TO_STAGE, init);
			// constructor code
		}// initialise trump
		private function init(e: Event): void {
			lose = new trumpLose;
			infranchi = [38, 39, 40, 41, 42, 43, 52, 53, 54, 70, 71, 61, 100];
			_vitDroite = 0;
			_vitGauche = 0;
			_vitHaut = 0;
			_vitBas = 0;

			_mort=false;// il n'est pas ENCORE mort
			addEventListener(Event.ENTER_FRAME, loop);
			Main(parent.parent.parent).addEventListener("reset", reset);

		}
		// fonction ENTER FRAME  comme les hit test, les déplacement
		private function loop(e: Event): void {
			// fait jouer l'animation avant que trump meur-----
			// selon les direction (juste un sera comenter car c'est les meme chose pour chaque)
			if (etat == "droite") {
				x += _vitDroite; // augmente sa vitesse () soi X ou Y 
				cpt += _vitDroite; // on augment les compteur (pour qu'il arrive au centre d'une tuile )
				if (cpt == 50) { // si le compteur est egale a 50 il arrete 
					etat = "arret";
					_posX++; //on change sa position dans la carte
				}
			}// voir etat=="droite"
			if (etat == "gauche") {
				x -= _vitGauche;
				cpt += _vitGauche;
				if (cpt == 50) {
					etat = "arret";
					_posX--;
				}
			}// voir etat=="droite"
			if (etat == "haut") {
				y -= _vitHaut;
				cpt += _vitHaut;
				if (cpt == 50) {
					etat = "arret";
					_posY--;
				}
			}// voir etat=="droite"
			if (etat == "bas") {
				y += _vitBas;
				cpt += _vitBas;
				if (cpt == 50) {
					etat = "arret";
					_posY++;
				}
			}


		}


		// DIRECTION + VITESSE ----------------------------------------------
		//fonction pour aller a droite
		public function allerDroite(): void {
			// on vérifi s'il il peux aller a la prochaine case 
			if (infranchi.indexOf(MovieClip(parent.parent).tMap[_posY][_posX + 1], 0) == -1 && etat == "arret") { // si le numéro N'est pas dans le table ( est égale a -1) il peux se déplacer 
				_vitDroite = _vitesse; // augmente la vitesse de déplacement
				gotoAndStop(4);// fait jouer l'animation 
				etat = "droite"; // change l'étate pour avoir un déplacement fluide
				cpt = 0; // initialise le compteur
			}

		}// voir la fonction aller droite
		public function allerGauche(): void {
			if (infranchi.indexOf(MovieClip(parent.parent).tMap[_posY][_posX - 1], 0) == -1 && etat == "arret") {
				//if( /*tMap[pos-1]==1 && */ etat == "arret") {
				etat = "gauche";
				cpt = 0;
				_vitGauche = _vitesse; // augmente la vitesse de déplacement
				gotoAndStop(8);
			}
		}// voir la fonction aller droite
		public function allerHaut(): void {
			if (infranchi.indexOf(MovieClip(parent.parent).tMap[_posY - 1][_posX], 0) == -1 && etat == "arret") {
				etat = "haut";
				cpt = 0;
				_vitHaut = _vitesse; // augmente la vitesse de déplacement 
				gotoAndStop(6);
			}

		}// voir la fonction aller droite
		public function allerBas(): void {
			if (infranchi.indexOf(MovieClip(parent.parent).tMap[_posY + 1][_posX], 0) == -1 && etat == "arret") {
				etat = "bas";
				cpt = 0;
				_vitBas = _vitesse;
				gotoAndStop(2);
			}
		}
		// arret de direction
		public function arretDroite(): void {
			gotoAndStop(3);
		}

		public function arretGauche(): void {
			gotoAndStop(7);
		}
		public function arretHaut(): void {
			gotoAndStop(5);
		}
		public function arretBas(): void {
			gotoAndStop(1);
		}


		//action
		// fonction pour activer un levier
		public function activer(): void {
			if (MovieClip(parent.parent).mapUn == true) { // vérifie sur qu'elle map trupm se situe
				if (MovieClip(parent.parent).nouvLevier != null) { // entre dans les colision si le clip n'est pas null
					for (var j: uint = 0; j < MovieClip(parent.parent).nouvLevier.numChildren; j++) { // on va chercher le nombre de levier en jeux
						if (Levier(Principal(parent.parent).nouvLevier.getChildAt(j)).hitLevier_mc.hitTestObject(this.hit_trump) || Levier(Principal(parent.parent).nouvLevier.getChildAt(j)).hitLevier_mc2.hitTestObject(this.hit_trump)) { // effectu les hitTest pour être sur que la cible n'embarque pas sur l'objet
							Levier(Principal(parent.parent).nouvLevier.getChildAt(j)).actif();// active la fonction actif dans leliver
							return void;
						}
					}
				}
			} else {
				if (MovieClip(parent.parent).nouvLevierDeux != null) { // entre dans les colision si le clip n'est pas null
					for (var k: uint = 0; k < MovieClip(parent.parent).nouvLevierDeux.numChildren; k++) { // on va chercher le nombre de levier en jeux
						if (LevierDeux(Principal(parent.parent).nouvLevierDeux.getChildAt(k)).hitLevier_mc.hitTestObject(this.hit_trump) || LevierDeux(Principal(parent.parent).nouvLevierDeux.getChildAt(k)).hitLevier_mc2.hitTestObject(this.hit_trump)) { // effectu les hitTest pour être sur que la cible n'embarque pas sur l'objet
							LevierDeux(Principal(parent.parent).nouvLevierDeux.getChildAt(k)).actifDeux();// active la fonction actif dans leliver
							return void;
						}
					}
				}
			}


		}
		// quand trump meur
		public function trumpMeur(): void {
			_mort = true // va permetre d'enlever l'ENTER_FRAME dans principal
			Principal(parent.parent).goFin(); // on va a la page de fin
			Principal(parent.parent).finParti();
			MovieClip(parent.parent.parent).fin_mc.gotoAndStop(2);
			lose.play();//fait jouer le son d'échec
		}
		// réinitiale le jeux
		public function reset(e:Event): void {
			_mort=false;
			addEventListener(Event.ADDED_TO_STAGE,init);
		}// permet de déplacer trump
		public function set trumpX(value: int): void {
			//anything here
			_posX = value;
		}// permet de déplacer trump
		public function set trumpY(value: int): void {
			//anything here
			_posY = value;
		}// donne la position de trump
		public function get posY(): uint {
			//anything here
			return _posY;
		}//donne la valeur de trump s'il est mort ou non
		public function get mort(): Boolean {
			//anything here
			return _mort;
		}
	} //class

} //pakage