import streamlit as st
import pandas as pd
#import psycopg2
import sqlalchemy
from sqlalchemy import create_engine



def main():
    #Creating PostgreSQL client
    engine = create_engine('postgresql://postgres:admin@localhost:5432/postgres')

    st.title('Sistema de cadastro telefônico') #Setta título

    menu = ['Descrição','Cadastrar Número', 'Cliente', 'Ligação', 'Fatura', 'Visões'] #Array com menus
    choice = st.sidebar.selectbox('Menu', menu) #Setta sidebar com selectbox

    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    #=-=-= PÁGINA DA DESCRIÇÃO DO PROJETO  =-=-= 
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

    if choice == 'Descrição':
        st.subheader('Descrição')
        
        st.subheader('Este trabalho é uma simulação de um sistema de cadastro telefônico, servindo apenas para compor a nota parcial da disciplina de Banco de Dados 2. Todas as informações são fictícias.')
        st.text('Equipe formada por: Diogo Gomes, Gustavo Galisa e Sandoellyton (o único)')

    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    #=-=-=-= PÁGINA PARA CADASTRAR NÚMERO -=-=-=
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

    elif choice == 'Cadastrar Número':
        st.subheader('Cadastrar Número')

        option = ['Criar novo número', 'Mostrar todos os números no banco']
        chip_op = st.sidebar.selectbox('Opções', option)

        #Aqui começa 'Cadastrar novo número > Criar novo número
        if chip_op == 'Criar novo número':
            
            st.subheader('Para criar um novo chip no banco de dados, forneça o DDD do estado, número da operadora e id do plano. O número será automaticamente criado e poderá ser visto com mais detalhes na aba "Mostrar todos os chip", onde estão todos os números.')
            
            ddd = st.text_input('Digite o DDD do estado desejado:',max_chars=2)
            operadora = st.text_input('Digite o ID da operadora ao qual o chip será vinculado:',max_chars=2)
            plano = st.text_input('Digite o ID do plano desejado:',max_chars=2)

            if st.button('Gerar número!'):
                #TODO comando para inserir ddd, operadora e plano
                #DONE????
                engine.execute("INSERT INTO chip VALUES (gerar_numero('{}','{}'),'{}','{}')".format(ddd, operadora, operadora, plano))
                st.success('Número gerado com sucesso!')
            
        #Aqui começa 'Cadastrar novo número > Mostrar todos os números no banco
        else:
            st.subheader('Aqui você pode ver todos os número cadastrados no banco de dados.')
            #TODO inserir comando para exibir (select * from chip)
            st.write(pd.DataFrame(engine.execute('select * from chip'))) #DONE?
            
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    #=-=-=-=-=-=SESSÃO DE CLIENTE=-=-=-=-=-=-=-=
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

    elif  choice == 'Cliente':
        st.subheader('Cliente')

        option = ['Cadastrar novo cliente', 'Mostrar chips disponíveis', 
                    'Cadastrar cliente em um chip', 'Cancelar cadastro de cliente',
                    'Analisar cliente', 'Chip por cliente']
        client_op = st.sidebar.selectbox('Cadastrar Número', option)

        if client_op == 'Cadastrar novo cliente':
            st.subheader('Digite as informações necessárias para cadastrar o novo cliente.')
            
            #idcliente = st.text_input('Digite o id do cliente (último da lista + 1):',max_chars=100)
            nome = st.text_input('Digite o nome completo do cliente:',max_chars=50)
            endereco = st.text_input('Digite o endereço:',max_chars=60)
            bairro = st.text_input('Digite o bairro:',max_chars=30)
            idCidade = st.text_input('Digite o id da cidade do cliente:')
            dataCadastro = st.date_input('Escolha a data do cadastro:')

            if st.button('Cadastrar cliente'):
                #TODO comando para inserir ddd, operadora e plano
                engine.execute("INSERT INTO cliente (nome, endereco, bairro, idCidade, dataCadastro) VALUES ('{}', '{}', '{}', {},'{}')".format(nome, endereco, bairro, idCidade, dataCadastro))
                st.success('Cliente cadastrado com sucesso!')
        
        #PÁGINA PARA MOSTRAR AO CLIENTE OS CHIPS DISPONÍVEIS
        if client_op == 'Mostrar chips disponíveis':
            st.subheader('Aqui estão todos os chips disponíveis no Estado e Operadora selecionados.')

            ddd_val = ["Selecione o DDD", '68', '82', '96', '92', '71', '85', '61', '27', '62', '98', '65', '67', '31', '91', '83', '41', '81', '86', '21', '84', '51', '69', '95', '47', '11', '79', '63']
            ddd = st.selectbox('Escolha o DDD', ddd_val)
            #ddd_chip = st.text_input('Digite o DDD do Chip:')

            operadora = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
            st.subheader('TIM = 1, Oi = 2, Claro = 3, VIVO = 4, NOS = 5, NOWO = 6, MEO = 7, NEXTEL = 8, EMBRATEL = 9, SERCOMTEL = 10')    
            num_disponiveis = st.selectbox('Escolha a operadora', operadora)
            
            #operadora_escolhida = st.text_input('Digite a operadora que deseja consultar:')
            if st.button('Exibir números!'):
                tabela = pd.DataFrame(engine.execute("select * from mostrar_numeros('{}',{})".format(ddd, num_disponiveis)))
                st.write(tabela)

        #CADASTRAR CLIENTE EM UM CHIP
        if client_op == 'Cadastrar cliente em um chip':
            st.subheader('Cadastre o cliente ao número escolhido.')

            cliente_id = st.text_input('Digite o ID do cliente:',max_chars=3)
            numero_id = st.text_input('Digite o número escolhido:',max_chars=11)

            if st.button('Cadastrar cliente ao chip'):
                #engine.execute("insert into cliente_chip values ('{}',{}).format(numero_id, cliente_id)")
                st.success('Cliente cadastrado com sucesso!')

        #CANCELAR O CADASTRO DE UM DETERMINADO CLIENTE
        if client_op == 'Cancelar cadastro de cliente':        

            st.subheader('Clique caso deseje listar todos os clientes com cadastro ativo.')
            if st.button('Mostrar clientes'):
                st.write(pd.DataFrame(engine.execute("select * from cliente where cancelado = 'N'")))
                st.success('Clientes exibidos com sucesso!')

            cliente_cancelado = st.text_input('Digite o ID do cliente que terá o cadastro cancelado:',max_chars=3)                
            st.subheader('Digite o ID do cliente que deseja ter o seu cadastro cancelado.')

            if st.button('Proceder operação'):
                engine.execute("UPDATE cliente SET cancelado = 'S' WHERE idCliente = '{}'".format(cliente_cancelado))
                st.success('Cliente cancelado com sucesso!')

        #ANALISAR DETERMINADO CLIENTE
        if client_op == 'Analisar cliente':                      
            st.subheader('Escolha o id do cliente para obter todos os detalhes do cadastro.')
            cliente_analise = st.text_input('Digite o ID do cliente que verificar:',max_chars=3)

            if st.button('Proceder operação'):
                st.write(pd.DataFrame(engine.execute("select * from cliente where idcliente = {}".format(cliente_analise))))
        
        #CHIPS ASSOCIADOS A DETERMINADO CLIENTE
        if client_op == 'Chip por cliente':                      
            st.subheader('Escolha o ID do cliente para verificar se existe algum chip associado a ele.')
            cliente_com_chip = st.text_input('Digite o ID do cliente que verificar:',max_chars=3)

            if st.button('Proceder operação'):
                st.write(pd.DataFrame(engine.execute("select cl.nome, ch.idnumero from cliente cl, cliente_chip ch where cl.idcliente = ch.idcliente and ch.idcliente = {}".format(cliente_com_chip))))


    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    #=-=-=-=-=-=SESSÃO DE LIGAÇÃO=-=-=-=-=-=-=-=
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

                    
    elif choice == 'Ligação':
        st.subheader('Ligação')

        option = ['Gerar ligações', 'Mostrar ligações a partir de um chip emissor', 'Mostrar ligações a partir de um chip receptor']
        lig_op = st.sidebar.selectbox('Opções', option)

        #GERAR LIGAÇÕES
        if lig_op == 'Gerar ligações':
            st.subheader('Digite os campos abaixo para gerar ligações aleatórias a partir do chip emissor.')

            data = st.date_input('Defina a data:')
            numero = st.text_input('Digite o número do emissor:',max_chars=11)
            
            if st.button('Proceder operação'):
                engine.execute("select * from gerar_ligacoes('{}','{}')".format(data, numero))
                st.success('Ligações geradas com sucesso!')

        #MOSTRAR LIGAÇÕES A PARTIR DE UM CHIP EMISSOR
        if lig_op == 'Mostrar ligações a partir de um chip emissor':
            st.subheader('Digite o número emissor para ver as datas de ligações, chip destino e duração das chamadas.')

            emissor = st.text_input('Digite o número do emissor:',max_chars=11)
            
            if st.button('Proceder operação'):
                st.write(pd.DataFrame(engine.execute("select data::date, chip_emissor, chip_receptor, duracao  from ligacao where chip_emissor = '{}'".format(emissor))))

            #MOSTRAR LIGAÇÕES A PARTIR DE UM CHIP RECEPTOR
        if lig_op == 'Mostrar ligações a partir de um chip receptor':
            st.subheader('Digite o número receptor para ver as datas de ligações, chip destino e duração das chamadas.')

            receptor = st.text_input('Digite o número do receptor:',max_chars=11)
            
            if st.button('Proceder operação'):
                st.write(pd.DataFrame(engine.execute("select data::date, chip_emissor, chip_receptor, duracao  from ligacao where chip_receptor = '{}'".format(receptor))))


    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
    #=-=-=-=-=-=SESSÃO DE FATURA =-=-=-=-=-=-=-=
    #=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

    #GERAR FATURAS                
    elif choice == 'Fatura':
        st.subheader('Sessão destinada unicamente a geração de faturas.')

        mes = st.text_input('Digite o mês das faturas que serão geradas:',max_chars=2)
        ano = st.text_input('Digite o ano das faturas que serão geradas:',max_chars=4)
                
        if st.button('Proceder operação'):
            engine.execute("select * from gerar_fatura('{}', '{}')".format(mes, ano))
            #st.write(pd.DataFrame())


#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
#=-=-=-=-=-=SESSÃO DE VISÕES =-=-=-=-=-=-=-=
#=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

    elif choice == 'Visões':
        st.subheader('Sessão destinada unicamente a geração de faturas.')

        option = ['Detalhamento de clientes', 'Mostrar faturamento', 'Ranking de planos']
        view_op = st.sidebar.selectbox('Opções', option)

        #VIEWS EXIGIDAS NO PROJETO
        if view_op == 'Detalhamento de clientes':
            st.subheader('Essa é a visão detalhada de todos os clientes do banco de dados.')
            if st.button('Exibir visão'):
                st.write(pd.DataFrame(engine.execute("select * from detalhamento_cliente")))
        
        if view_op == 'Mostrar faturamento':
            st.subheader('Essa visão detalha o faturamento.')
            if st.button('Exibir visão'):
                st.write(pd.DataFrame(engine.execute("select * from faturamento")))

        if view_op == 'Ranking de planos':
      
            st.subheader('Essa visão traz informações sobre os planos mais comercializados.')
            if st.button('Exibir visão'):
                st.write(pd.DataFrame(engine.execute("select * from ranking_planos")))




















































if __name__ == '__main__':
    main()