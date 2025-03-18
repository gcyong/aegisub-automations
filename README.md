# Aegisub 오토메이션을 위한 Lua 5.1 스크립트

Aegisub의 근황을 살펴보니 TypesettingTools라는 곳에서 [Aegisub 리포지토리](https://github.com/TypesettingTools/Aegisub)를 관리하고 있었습니다. 그동안 이 리포지토리의 존재를 모르고 Aegisub 프로젝트가 중단되었다는 듯한 뉘앙스로 잘못 적었나 싶었습니다. 하지만 (다행히도) 그런건 아니었고, 2024년 12월 19일 3.4.0 버전을 시작으로 프로젝트를 재개한 것이었습니다.

제가 알고있는 Aegisub의 최신 버전은 3.2.2 였는데요, 그동안 소식을 찾아보지 않아 3.3.x 버전의 존재도 모르고 있었나 싶었습니다. 하지만 (역시나 다행히도) 그런건 아니었고, Aegisub의 여러 포크된 프로젝트에서 3.3.x 버전으로 태그를 생성했기 때문에 이들과 충돌을 피하고자 버전을 한 번에 두 개 올린 것으로 확인 했습니다.

>The version is 3.4.0 to avoid conflicts with forks that tagged things under 3.3.x. - [Aegisub 3.4.0 Released](https://aegisub.org/blog/aegisub-3.4.0-released)

프로젝트가 다시 재개되어 이전에 README에 적어두었던 내용 중 일부는 더 이상 해당되지 않아 조금 수정했습니다. 이전 내용이 궁금하시다면, 이전 내용으로 가장 최신 버전의 README가 커밋되어 있는 2f0a56f를 참고하세요.

## 참고 사이트
Aegisub에서 제공하는 기능은 아래 사이트에서 참고하시면 됩니다.

* [Aegisub 공식 사이트](https://aegisub.org/)
* [TypesettingTools/Aegisub](https://github.com/TypesettingTools/Aegisub)
    * 이 리포지토리는 [공식 리포지토리](https://github.com/Aegisub/Aegisub)의 포크 버전입니다만, 공식 리포지토리에 이어서 프로젝트를 관리하고 있습니다. 최신 버전 릴리즈 및 소식을 확인하기 위해서는 TypesettingTools/Aegisub 리포지토리를 방문하는 것이 좋습니다.
* [Aegisub 3.4.2 버전 매뉴얼](https://aegisub.org/docs/latest/main_page/)
* [Lua 5.1 공식 레퍼런스](https://www.lua.org/manual/5.1/)

## 연락
만일 이 리포지토리나 Aegisub에 대한 문의가 있으시면 아래 링크를 참고하세요. 사실, 모든 문제를 해결해 드리기에는 제 그릇이 작아 함께 고민해보는 데 의의를 두셨으면 좋겠습니다.

 * 이메일 : [gcyong@outlook.com](mailto:gcyong@outlook.com)  
 * 블로그 : [http://gcyong.tistory.com](http://gcyong.tistory.com)
