import 'package:flutter/material.dart';
import '../widgets/cat.dart';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  @override
  void initState() {
    super.initState();

    catController = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    );

    catAnimation = Tween(begin: 0.0, end: 200.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  onTap() {
    if (catController.status == AnimationStatus.completed)
      return catController.reverse();

    if (catController.status == AnimationStatus.dismissed)
      return catController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animation!'),
      ),
      /*
      GestureDetector: Funciona para TODOS
      os filhos. Mesmo numa estrutura aninhada,
      o evento vai subir até encontrar esse onTap.
       */

      body: GestureDetector(
        child: buildAnimation(),
        onTap: onTap,
      ),
    );
  }

  Widget buildAnimation() {
    return AnimatedBuilder(
      animation: catAnimation,
      /*
      No StreamBuilder, a cada mudança criamos tudo
      dentro do builder, o que é o ok para user input.
      Para uma animação de 60fds, é inviável criar
      um novo a cada 1/60segundos, então temos o child
      e mudamos apenas o valor que estamos interessados,
      mantendo o mesmo widget construido.

      O único jeito de fazer um update na ui é criando
      um novo widget... Ainda sim esse método de passar
      o child ajuda para o caso de seu objeto animado
      ser muito custoso, então você pode criar um menor,
      como um Container.
      [V0.44] Interessante verificar nas documentações
      oficiais se isso não foi melhorado de alguma forma,
      pois tem cara de uma oportunidade de melhoria aqui.



      Animações em Flutter:
      As classes não sabem sobre sua animação... Sabem apenas
      sobre valores que vão mudar de acordo com o tempo,
      você mesmo utiliza esses valores para criar outros
      componentes (containers são leves para criar) para criar
      cada frame. São basicamente helpers para criar seus frames.
       */
      builder: (context, child) {
//        print('catAnimation: ${catAnimation.value}');
        return Container(
          child: child,
          margin: EdgeInsets.only(top: catAnimation.value),
        );
      },
      child: Cat(),
    );
  }
}
