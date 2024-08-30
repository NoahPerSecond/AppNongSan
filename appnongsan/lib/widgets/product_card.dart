import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image(
                width: 150,
                height: 120,
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://images.baodantoc.vn/uploads/2022/Th%C3%A1ng%208/Ng%C3%A0y_12/Thanh/ghep-cay-nho.jpg',
                ),
              ),
            ),
            
        
          ],
        ),
        Text('Nho'),
        Row(
  children: List.generate(5, (index) {
    return Icon(
      Icons.star,
      color: index < 4 ? Colors.yellow : Colors.grey,
    );
  }),
)
      ],
    );
  }
}
