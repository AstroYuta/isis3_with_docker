# isis3_with_docker
This is a provate repository for crating isis3 environment utilizing the docker. DO NOT PUBLICLY USE THE REPOSITORY. Please contact shimizu@seed.um.u-tokyo.ac.jp for the usage of this repository.

# 環境の準備 (ざっくり書きます)
## Windows
1. Gitのインストール
    - https://git-scm.com/download/win からgitをインストールするための.exeをダウンロードする
    - .exeを実行してgitをインストールする
     - 参考: https://qiita.com/kerobot/items/78372640127771f92ee0

2. Git repositoryを落としてくる

    powershellなどを開き、任意のディレクトリに行く
    ```
    cd C:￥hogehogemoge
    ```

    git repositoryをcloneする
    ```
    git clone https://github.com/AstroYuta/isis3_with_docker.git
    ```

3. Docker環境を整える
    - https://qiita.com/suzuyui/items/22e76a6a27f0b6f2492a こいつを参考にdocker for windowsをインストール
      - 2.1.2 WSL2有効化 2.1.3 Docker for Windowsをインストールだけでいいと思う
      - WSL2がはいっているならwindows 10 アップデートもせんでいいはず
    - 起動するか `Dockerテスト実行` のとこに書いてあるやつで確認してください
    
4. imageのビルドとコンテナの立ち上げ
    ワークディレクトリを設定する
    ```
    dir をうつ
    ディレクトリ: (ここをコピーしておく)    
    テキストエディタ (メモ帳) などでdocker-compose.ymlをひらく
    ${WORK_SPACE:-default}の部分をコピーしたパスで置き換える
    ```

    docker-composeでビルド
    ```
    cd isis3_with_docker
    docker-compose build
    ```
    
    dockerコンテナを立ち上げる
    ```
    docker-compose up -d
    ```
    
    コンテナが立ち上がったか確認
    ```
    docker ps -a
    
    こんな感じでコンテナが表示され、STATUSがUPになっていたら立ち上がってる
    CONTAINER ID   IMAGE             COMMAND               CREATED         STATUS         PORTS                   NAMES
    c48e909e419b   astroyuta/isis3   "/usr/sbin/sshd -D"   9 minutes ago   Up 9 minutes   0.0.0.0:22000->22/tcp   isis3
    ```
5. Mobaxtermのインストール
    - ここ (https://mobaxterm.mobatek.net/download-home-edition.html) からMobaXterm home editionをインストール
    - zipを作業フォルダに解凍して、.exeからMobaXtermをたちあげる

6. MobaXtermでコンテナにはいる
    Session > SSHを選択

    こんな感じの設定で接続してちょ

    <img width="639" alt="キャプチャ" src="https://user-images.githubusercontent.com/26423415/98220950-62e82780-1f92-11eb-8b29-82596d263e40.PNG">
    
    パスワードはisis
    
    MobaXtermがパスワード登録するか聞いてくるけど任せます
    
    こんな感じの画面が出てきたらログイン成功
    
    <img width="639" alt="キャプチャ" src="https://user-images.githubusercontent.com/26423415/98221579-2406a180-1f93-11eb-8175-5f83d1f48427.png">

    GUIが起動できるか試す
    
    ```
    xeyes
    ```
    
    目がでてきた？
    
    ![image](https://user-images.githubusercontent.com/26423415/98221844-7cd63a00-1f93-11eb-8781-db1f2257f502.png)

7. isisの環境を整備する
    ```
    # Activate
    conda activate isis3
    
    # パスを設定する
    cd /home/workspace
    mkdir isis3
    python $CONDA_PREFIX/scripts/isis3VarInit.py --data-dir=/home/workspace/isis3/data  --test-dir=/home/workspace/isis3/testData
    conda activate isis3
    echo $ISIS3DATA の結果が /home/workspace/isis3/data になってるか確認
    
    # base data をダウンロード
    cd $ISIS3DATA
    rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isis3data/data/base .
    
    # qviewなどが立ち上がるかチェック
    qview
    立ち上がった？？？
    ```
8. LROやMROなど研究に応じてbaseをダウンロードする
    ```
    例 LROの場合
    cd $ISIS3DATA
    rsync -azv --delete --partial isisdist.astrogeology.usgs.gov::isisdata/data/lro .
    ```

## Mac OS
- MobaXtermじゃなくてXQuartzを入れる
- ~/.ssh/configに設定を追加する
```
Host *
  XAuthLocation /opt/X11/bin/xauth
  ForwardX11 yes
  ForwardX11Trusted yes
Host hoge
  HostName	IP adress
  Port		22000
  IdentityFile 	~/.ssh/reid_san
  LocalForward  22000 localhost:22000
  User 		hogehoge
```

# 終わる場合
```
powershellで
docker-compose down
```

# 作業を再開する場合
```
powershellで docker-compose up -d

6. の手順でMobaXtermを用いてログインする

cd /home/workspace
conda activate isis3
python $CONDA_PREFIX/scripts/isis3VarInit.py --data-dir=/home/workspace/isis3/data  --test-dir=/home/workspace/isis3/testData
conda activate isis3
```

これで快適なisis生活を！！！
やっほっす～
    
