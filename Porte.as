package  {
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundMixer;
	public class Porte extends MovieClip{
		private var ouvre:Sound;
		public function Porte() {
			// constructor code
			addEventListener(Event.ADDED_TO_STAGE, init);
		}// initialise la porte
		private function init(e:Event):void {
			Main(parent.parent.parent).addEventListener("reset", reset);
			ouvre=new sonPorte; // ajoute le son de la porte
		}// si la porte s'ouvre
		public function ouvrire():void{ 
			if(currentFrame==1){
				gotoAndPlay(3);// fait jouer l'animation
				ouvre.play();// fait jouer le son
			}
		}// reinitialise la porte
		public function reset(e:Event):void{
			gotoAndStop(1);
		}
	}
}