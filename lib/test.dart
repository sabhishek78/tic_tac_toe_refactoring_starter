
import 'main.dart';

import 'package:test/test.dart';
void main() {

  test('all pairs', (){
    expect(([2, 4, 5, 3], 7),[[2, 5], [3, 4]]);
    expect(allPairs([2, 4, 5, 3], 8),[[3,5]]);
    expect(allPairs([2, 4, 5, 3], 10),[]);
    expect(allPairs([-2, 4, -5, 3], -2),[[-5, 3]]);

  });
  test('almost sorteed', (){

    expect(almostSorted([1, 3, 5, 9, 11, 80, 15, 33, 37, 41] ),true);
    expect(almostSorted([1, 3, 5, 9, 11, 13, 15, 33, 37, 41] ),false);
    expect(almostSorted([1] ),false);
  });
}