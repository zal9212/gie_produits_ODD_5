import 'package:flutter/material.dart';

// Modèle d'un slide du carousel
class CarouselSlide {
  final String titre;
  final String sousTitre;
  final String? imagePath; // chemin dans assets
  final Color couleurFond; // couleur de fond si pas d'image
  const CarouselSlide({
    required this.titre,
    required this.sousTitre,
    this.imagePath,
    this.couleurFond = const Color(0xFF2D5016),
  });
}

class HeroCarousel extends StatefulWidget {
  final List<CarouselSlide> slides;
  final double height;
  const HeroCarousel({
    super.key,
    required this.slides,
    this.height = 180,
  });
  @override
  State<HeroCarousel> createState() => _HeroCarouselState();
}

// StatefulWidget car on gere l'index du slide actif
class _HeroCarouselState extends State<HeroCarousel> {
// PageController contrôle le défilement horizontal
  final PageController _pageController = PageController();
  int _currentIndex = 0; // index du slide visible
  @override
  void dispose() {
    _pageController.dispose(); // libérer la mémoire
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
//  LE CAROUSEL 
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.slides.length,
// Appelé à chaque changement de page
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            itemBuilder: (context, index) {
              final slide = widget.slides[index];
              return _buildSlide(slide);
            },
          ),
        ),
        const SizedBox(height: 10),
//  INDICATEURS POINTS 
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.slides.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentIndex == index ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
// Point actif = large et sombre / inactif = petit et gris
                color: _currentIndex == index
                    ? const Color(0xFF1A1A1A)
                    : const Color(0xFFD0CEC8),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSlide(CarouselSlide slide) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: slide.couleurFond, // couleur de fond par défaut
      ),
      clipBehavior: Clip.hardEdge,
      child: Stack(
        fit: StackFit.expand,
        children: [
// ── IMAGE DE FOND (si disponible) ──
          if (slide.imagePath != null)
            Image.asset(
              slide.imagePath!,
              fit: BoxFit.cover,
// Si l'image ne charge pas → on ignore, le fond coloré reste
              errorBuilder: (_, __, ___) => const SizedBox(),
            ),
// ── DÉGRADÉ SOMBRE PAR-DESSUS L'IMAGE ──
// Pour que le texte blanc reste lisible
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.1),
                  Colors.black.withOpacity(0.55),
                ],
              ),
            ),
          ),
// ── TEXTE CENTRÉ ──
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slide.titre,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      height: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    slide.sousTitre,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.85),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
