import 'package:flutter/material.dart';

class LearnPage extends StatelessWidget {
  const LearnPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryGreen = Color(0xFF4CAF50);
    final topics = [
      _Topic(
        title: '🌱 Les capteurs',
        description:
        'Les capteurs de sol mesurent l’humidité pour savoir quand arroser.',
        imageUrl:
        'https://cepmaroc.com/111-large_default/capteur-d-humidite-de-sol-soil-yl-69.jpg',
      ),
      _Topic(
        title: '🚿 Les pompes',
        description:
        'Les pompes envoient l’eau du réservoir vers les tuyaux.',
        imageUrl:
        'https://www.serresvaldeloire.com/img/pompes-centrifuges-monobloc-taraudees-nm-nmd1.jpg',
      ),
      _Topic(
        title: '🔧 Les vannes',
        description:
        'Les vannes s’ouvrent ou se ferment automatiquement pour contrôler l’eau.',
        imageUrl:
        'https://cdn.manomano.com/media/edison/b/a/8/9/ba89257b79dc.jpg',
      ),
      _Topic(
        title: '💧 Cycle de l’eau',
        description:
        'Découvre comment l’eau circule dans la ferme et revient aux plantes.',
        imageUrl:
        'https://escape-kit.com/wp-content/uploads/2022/02/cycle-de-l-eau-min-1030x785.png',
      ),
      _Topic(
        title: '🌞 Bonnes pratiques',
        description:
        'Arroser tôt le matin, pailler le sol et vérifier les capteurs régulièrement.',
        imageUrl:
        'https://images.unsplash.com/photo-1501004318641-b39e6451bec6?auto=format&fit=crop&w=400&q=60',
      ),
      _Topic(
        title: '🧠 Pourquoi irriguer ?',
        description:
        'L’irrigation aide les plantes à grandir même quand il ne pleut pas.',
        imageUrl:
        'https://cdn.pixabay.com/photo/2020/08/01/10/01/the-cultivation-of-5455003_1280.jpg',
      ),
      _Topic(
        title: '👩‍🌾 Les outils d’un fermier',
        description:
        "Les fermiers utilisent des outils comme l'arrosoir. Un arrosoir aide à donner de l'eau aux plantes doucement, comme si on leur donnait un petit bain.",


        imageUrl:
        'https://cdn.pixabay.com/photo/2017/07/19/08/50/gardening-2518377_1280.jpg',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFFFFAF0),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Banner
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: primaryGreen,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.book, color: Colors.white),
                    SizedBox(width: 12),
                    Text(
                      'Apprends les bases de l’irrigation !',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'ComicSans',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: topics.length,
                itemBuilder: (context, index) {
                  final t = topics[index];
                  return InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          title: Text(t.title),
                          content: Text(
                            t.description,
                            style: const TextStyle(fontFamily: 'ComicSans'),
                          ),
                          actions: [
                            TextButton(
                              child: const Text('Fermer'),
                              onPressed: () => Navigator.of(context).pop(),
                            )
                          ],
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(20)),
                              child: Image.network(
                                t.imageUrl,
                                fit: BoxFit.cover,
                                loadingBuilder: (context, child, progress) {
                                  if (progress == null) return child;
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              t.title,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'ComicSans',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Topic {
  final String title;
  final String description;
  final String imageUrl;

  _Topic({
    required this.title,
    required this.description,
    required this.imageUrl,
  });
}
