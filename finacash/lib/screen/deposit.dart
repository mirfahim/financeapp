import 'package:finacash/Helper/Movimentacoes_helper.dart';
import 'package:finacash/Widgets/TimeLineItem.dart';
import 'package:flutter/material.dart';

class ReceitasResumo extends StatefulWidget {
  @override
  _ReceitasResumoState createState() => _ReceitasResumoState();
}

class _ReceitasResumoState extends State<ReceitasResumo> {

  String saldoAtual = "";
  var total;
  TextEditingController _valorController = TextEditingController();

  MovimentacoesHelper movimentacoesHelper = MovimentacoesHelper();
  List<Movimentacoes> listmovimentacoes = List();
  String format(double n) {
    return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  }

  _allMovPorTipo() {
    movimentacoesHelper.getAllMovimentacoesPorTipo("r").then((list) {
      setState(() {
        listmovimentacoes = list;
      });
      print("All Mov: $listmovimentacoes");
    });
  }

  // testing total
_addValor() {
    String valor = _valorController.text;
    setState(() {
      saldoAtual = valor;
    });
  }


  _allMovMes(String data) {
    movimentacoesHelper.getAllMovimentacoesPorMes(data).then((list) {
      if (list.isNotEmpty) {
        setState(() {
          listmovimentacoes = list;
          //total =listmovimentacoes.map((item) => item.valor).reduce((a, b) => a + b);
        });
        total =
            listmovimentacoes.map((item) => item.valor).reduce((a, b) => a + b);
        saldoAtual = format(total).toString();
      } else {
        setState(() {
          listmovimentacoes.clear();
          total = 0;
          saldoAtual = total.toString();
        });
      }

      //print("TOTAL: $total");
      //print("All MovMES: $listmovimentacoes");
    });
  }
  
// testing end
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _allMovPorTipo();
  }
  
  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green.withOpacity(0.8),
      body: SingleChildScrollView(
        physics: ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: width * 0.05,top: width * 0.2),
              child: Text("Deposit",style: TextStyle(
                color: Colors.white ,//Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: width * 0.08
              ),),
              
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.02,top: width * 0.1),
              child: Text(saldoAtual,style: TextStyle(
                color: Colors.white ,//Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: width * 0.03
              ),),
              
            ),
            Padding(
              padding: EdgeInsets.only(left: width * 0.03, top: width * 0.08),
              child: SizedBox(
                width: width,
                height: height * 0.74,
                child: ListView.builder(
                  itemCount: listmovimentacoes.length,
                  itemBuilder: (context, index){
                    List movReverse = listmovimentacoes.reversed.toList();
                    Movimentacoes mov = movReverse[index];

                    
                    if(movReverse[index] == movReverse.last){
                      return TimeLineItem(mov: mov, colorItem: Colors.green[900],isLast: true,);
                    }else{
                      return TimeLineItem(mov: mov,colorItem: Colors.green[900],isLast: false,);
                    }
                    
                  },
                ),
              ),
              
            ),
            
          ],
        ),
      ),
      
    );
  }
}