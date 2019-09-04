package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	public class Levier extends MovieClip{
		private var _levierActif:Boolean; // initialisastion des levier 
		private var t:Trump=new Trump();
		private var levier:Sound;
		
		public function Levier() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		private function init(e:Event):void {
			_levierActif=false; // tout les levier son inactif au départ (aucun ne fait parti de l'énigme) on le change dans principale
			levier=new sonLevier// ajout du son
			Main(parent.parent.parent).addEventListener("reset", reset);
		}
		private function loop(e:Event):void{
			if(this.currentFrame==14){ // si le levier ne fait pas parti de l'énigme
				Trump(Principal(parent.parent).nouvTrump.getChildAt(0)).trumpMeur(); // tue trump
					finPartiL(); // parti fini
					removeEventListener(Event.ENTER_FRAME, loop);
				
			}else if(this.currentFrame==8){ // si le levier fait parti de l'énigme 
				removeEventListener(Event.ENTER_FRAME, loop); // enleve son loop
			}
			
		}
		
		public function actif():void{
			addEventListener(Event.ENTER_FRAME, loop);
			// si le levier fait parti de l'énigme
			if(_levierActif==true){
				gotoAndPlay(2); // joue lanimation en conséquence
				MovieClip(parent.parent).removeEnigmeUn();
				_levierActif=false;
			}else{ // si ne fait pas parti de l'énigme
				gotoAndPlay(9);// joue lanimation en conséquence
			}
			levier.play(); // dans les 2 cas joue le son
			
		}// permet de changer la valeur du levier
		public function set levierActif(x:Boolean):void{
			_levierActif = x;   
		}	 
		public function get leevierActif():Boolean{
			return _levierActif;   
		}// fin de la parti
		public function finPartiL():void{
			//MovieClip(parent).removeChild(this);
			removeEventListener(Event.ADDED_TO_STAGE,init);
			removeEventListener(Event.ENTER_FRAME, loop);
		}// réinitialise les levier
		private function reset(e:Event):void{
			gotoAndStop(1);
			addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
	}//class
	
}//package
