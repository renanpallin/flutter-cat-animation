import 'package:flutter/material.dart';
import '../widgets/cat.dart';
import 'dart:math';

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> with TickerProviderStateMixin {
  Animation<double> catAnimation;
  AnimationController catController;

  Animation<double> boxAnimation;
  AnimationController boxController;

  @override
  void initState() {
    super.initState();

    boxController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    boxAnimation = Tween(
      begin: pi * 0.6,
      end: pi * 0.65,
    ).animate(
      CurvedAnimation(
        parent: boxController,
        curve: Curves.easeInOut,
      ),
    );

    boxController.addStatusListener((status) {
//      print('changed: $status');
      if (status == AnimationStatus.completed) {
        boxController.reverse();
      } else if (status == AnimationStatus.dismissed) {
        boxController.forward();
      }
    });
    boxController.forward();

    catController = AnimationController(
      duration: Duration(milliseconds: 200),
      vsync: this,
    );

    catAnimation = Tween(begin: -35.0, end: -80.0).animate(
      CurvedAnimation(
        parent: catController,
        curve: Curves.easeIn,
      ),
    );
  }

  onTap() {
    if (catController.status == AnimationStatus.completed) {
      boxController.forward();
      catController.reverse();
    }

    if (catController.status == AnimationStatus.dismissed) {
      boxController.stop();
      catController.forward();
    }
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
        child: Center(
          child: Stack(
            children: <Widget>[
              buildCatAnimation(),
              buildBox(),
              buildLeftFlap(),
              buildRightFlap(),
            ],
            overflow: Overflow.visible,
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  Widget buildCatAnimation() {
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
        return Positioned(
          child: child,
          top: catAnimation.value,
          left: 0.0,
          right: 0.0,
        );
      },
      child: Cat(),
    );
  }

  Widget buildBox() {
    return Container(
      height: 200,
      width: 200,
      color: Colors.brown,
    );
  }

  Widget buildLeftFlap() {
    return Positioned(
      left: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topLeft,
            angle: boxAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.red,
        ),
      ),
    );
  }

  Widget buildRightFlap() {
    return Positioned(
      right: 3.0,
      child: AnimatedBuilder(
        animation: boxAnimation,
        builder: (context, child) {
          return Transform.rotate(
            alignment: Alignment.topRight,
            angle: -boxAnimation.value,
            child: child,
          );
        },
        child: Container(
          height: 10.0,
          width: 125.0,
          color: Colors.red,
        ),
      ),
    );
  }
}
