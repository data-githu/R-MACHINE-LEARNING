■ R 을 활용한 머신러닝 11장 - 모델성능개선 5. random forest 

1. random forest가 무엇인가?
  
의사결정트리는 오버피팅이 될 가능성이 높다는 약점을 가지고 있습니다. 가지치기를 통해 최대 높이를 조정해서 오버피팅될 가능성을 낮출 수는 있지만 이것만으로는 오버피팅 문제를 해결하기에 충분하지 않습니다. 
그래서 의사결정트리에 앙상블 기법을 추가해서 훈련데이터를 여러 의사결정트리 모델들이 샘플링하여 학습하고 예측결과를 투표하여 가장 많이 득표한 결과를 최종 분류의 결과로 선택합니다.


2. random forest는 어떻게 수행되어 지는가?
  
랜덤포레스트는 제일 먼저 bagging 이라는 과정을 수행합니다.
bagging 은 트리를 만들어 training set의 부분집합을 활용하여 형성하는 것을 말합니다. 
모든 트리는 각기 다른 데이터를 바탕으로 형성이 되며 예측 결과는 최종투표결과로 산출됩니다.


3. random forest의 하이퍼 파라미터는 무엇입니까?
- ntree : 몇개의 나무를 생성할 지를 설정하는 인자
- mtry : 각 노드에서 랜덤하게 고려될 변수의 갯수를 지정
- nodesize : 나무의 깊이를 설정하는 인자로 최소한의 노드의 갯수를 뜻합니다. 이 값이 크면 깊이가 얕은 나무가 생성되고 이 값이 작으면 깊이가 깊은 나무가 생성된다.



