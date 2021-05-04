/// cardNo : "0001208000001428"

class CardBalByCardNoBody {
  String _cardNo;

  String get cardNo => _cardNo;

  CardBalByCardNoBody({
      String cardNo}){
    _cardNo = cardNo;
}

  CardBalByCardNoBody.fromJson(dynamic json) {
    _cardNo = json["cardNo"];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map["cardNo"] = _cardNo;
    return map;
  }

}