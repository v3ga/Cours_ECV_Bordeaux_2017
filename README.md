Design interactif — ECV Bordeaux — 2016 / 2017
===============================================

## Projet Mollat
Le projet est de présenter une installation interactive pour la vitrine « Beaux Arts » de la librairie Mollat (rue Porte Dijeaux)
Cette exposition sera centrée autour du thème du **portrait** en proposant aux spectateurs un miroir dynamique dans lequel leur apparence
sera transformée ou augmentée en temps réel. La scénographie de cette vitrine sera composée à priori de trois éléments principaux : 
* **un écran** diffusant les créations en boucle en invitant le spectateur à approcher.
* **des affiches** présentant des portraits de passants, imprimées avec le traceur [SAM](http://www.samdraws.fabprojects.codes/).
* **une sélection d’ouvrages** relatifs à la «code culture».

D'autre part la [station Ausone](http://www.station-ausone.com/) sera aussi investie comme lieu de résidence pour préparer l'exposition en vitrine et présenter aussi au public
le processus de fabrication des affiches au public. Le lieu fera l'objet d'une scénographie particulière en lien direct avec la vitrine. 

![Interface](http://v3ga.github.io/Images/Cours_ECV_Bordeaux_2017/Mollat_vitrine_beaux_arts.jpg)

### SAM
SAM est une machine à dessiner qui a été développée et produite à l’[ESAD Amiens](http://www.esad-amiens.fr/) par **Mark Webster** et **Victor Jean Meunier**. 
Ce type de machines a été utilisée par les artistes utilisant la programmation dans les années 50 et 60 pour visualiser et produire leurs œuvres.

![SAM](https://c2.staticflickr.com/3/2906/14682805705_5c23134172_c.jpg)
![SAM](https://c8.staticflickr.com/6/5612/29774928991_cabf60127a_m.jpg)
![SAM](https://c2.staticflickr.com/9/8306/29124170841_6a88f20956_m.jpg)
![SAM](https://c2.staticflickr.com/6/5080/29984061465_d340c89cb2_m.jpg)

* Site web du projet : http://www.samdraws.fabprojects.codes/
* Photos : https://www.flickr.com/photos/tisane_01/sets/72157645344025569/with/28856205243/
* Github : https://github.com/FreeArtBureau/SAM
* Github dédié au projet : https://github.com/FreeArtBureau/SAM/tree/master/PROJET_MOLLAT

### Références
* Raven Kwok — [Sans titre](https://www.facebook.com/ravenkwok.art/videos/606638642830167/)
* Generative gestaltung — [P_4_3_2_01](http://www.generative-gestaltung.de/P_4_3_2_01)
* Generative gestaltung — [P_4_3_1_01](http://www.generative-gestaltung.de/P_4_3_1_01)
* Daniel Rozin — http://www.smoothware.com/danny/ et notamment le génial [Pom Pom Mirror](http://www.bitforms.com/rozin/pompom-mirror) ou encore 
* Zachary Lieberman — https://www.instagram.com/p/BDlMXqlpNuW/
* Kyle McDonald — [Face substitution](https://vimeo.com/29348533)
* Mario Kinglemann — [Google experiments](https://www.fastcodesign.com/3062016/this-neural-network-makes-human-faces-from-scratch-and-theyre-terrifying) + [ici](http://prostheticknowledge.tumblr.com/post/147652093136/neural-network-portraits-examples-of-images-from)
* Daniel Shiffman — [Face it syllabus @ ITP](https://github.com/shiffman/Face-It)
* Golan Levin — [workshop @ Carnegie](Mellon http://golancourses.net/2013/category/project-1/face-osc/)
* Julien Gachadoat — [Delaunay man](https://www.flickr.com/photos/v3ga/15820575937/in/dateposted-public/)
* Julien Gachadoat — [Visages](http://www.v3ga.net/blog2/2014/03/visages/)

### Intervenants
* Julien Gachadoat de [2Roqs](http://www.2roqs.fr)
* Benjamin Ribeau de [Kubik](http://kubik.fr/) : scénographie vitrine + station Ausone.
* [Mark Webster](http://mwebster.flavors.me/) : impressions avec le traceur SAM.

### Bibliographie
* Magazine Holo — http://holo-magazine.com/2/
* Design génératif — https://pyramyd-editions.com/products/design-generatif
* Processing : A programming handbook for visual designers — https://mitpress.mit.edu/books/processing-0
* Form + Code — http://formandcode.com/
* 10 PRINT ... (Software Studies) — http://reas.com/10_print/
* 6|5 — http://www.zones-sensibles.org/livres/6-5/
* Creative code — http://www.maedastudio.com/2004/creativecode/index.php?category=all&next=2003/robotill&prev=2005/clog&this=creative_code
* A Little-Known Story about a Movement, a Magazine, and the Computer’s Arrival in Art — https://mitpress.mit.edu/books/little-known-story-about-movement-magazine-and-computer%E2%80%99s-arrival-art
* A touch of code — http://shop.gestalten.com/a-touch-of-code.html

### Déroulé
Par rapport à l'année dernière, les séances auront lieu sur des temps d'ateliers d'une journée plutôt que des cours pour se focaliser sur 
le processus d'expérimentations. Ces séances auront lieu **de début octobre jusqu'à fin novembre**.

Un temps de résidence sera organisé **au mois de janvier** avant l'accrochage en vitrine, la semaine du 3 Janvier. 

<a name="cours01" />
## Cours #01 — redémarrer ou setupagain() — Vendredi 7 octobre
* Prise en main de Processing, différence avec p5.js
* Révisions des notions : gestionnaires setup() / draw(), variables, boucles, conditions
* Utilisation de la caméra dans Processing

## Atelier #01 - détection de visage - Jeudi 20 octobre
* gestion de la caméra avec Processing
  * installation de la librairie vidéo, type de données Capture.
* traitement d'images avec Processing: 
  * redimensionnement
  * traitement de l'image pixel <-> motif géométrique dynamique
* utilisation de [FaceOSC](https://github.com/kylemcdonald/ofxFaceTracker/releases)   
  * [templates / exemples](https://github.com/CreativeInquiry/FaceOSC-Templates/tree/master/processing)  
