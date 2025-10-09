package br.ufrpe.bds.assistech.view;

import javax.swing.*;
import javax.swing.table.DefaultTableModel;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class TabelaComFormulario extends JFrame {

    private DefaultTableModel modelo;
    private JTable tabela;
    private JTextField campoNome;
    private JTextField campoSobrenome;
    private JTextField campoTelefone;
    private JTextField campoEndereco;

    public TabelaComFormulario() {
        super("Cadastro de Clientes");

        // ---------- Painel superior (formulário) ----------
        JPanel painelFormulario = new JPanel(new GridLayout(2, 4, 10, 10));
        painelFormulario.setBorder(BorderFactory.createTitledBorder("Novo Cliente"));

        campoNome = new JTextField();
        campoSobrenome = new JTextField();
        campoTelefone = new JTextField();
        campoEndereco = new JTextField();

        painelFormulario.add(new JLabel("Nome:"));
        painelFormulario.add(campoNome);
        painelFormulario.add(new JLabel("Sobrenome:"));
        painelFormulario.add(campoSobrenome);

        painelFormulario.add(new JLabel("Telefone:"));
        painelFormulario.add(campoTelefone);
        painelFormulario.add(new JLabel("Endereço:"));
        painelFormulario.add(campoEndereco);

        // ---------- Botão de adicionar ----------
        JButton botaoAdicionar = new JButton("Adicionar");
        botaoAdicionar.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                adicionarCliente();
            }
        });
        
        // ---------- Botão de excluir ----------
        JButton botaoExcluir = new JButton("Excluir");
        botaoExcluir.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                adicionarCliente();
            }
        });

        JPanel painelBotao = new JPanel();
        painelBotao.add(botaoAdicionar);
        painelBotao.add(botaoExcluir);
        

        // ---------- Tabela ----------
        String[] colunas = {"Nome", "Sobrenome", "Telefone", "Endereço"};
        modelo = new DefaultTableModel(colunas, 0);
        tabela = new JTable(modelo);
        JScrollPane scrollPane = new JScrollPane(tabela);

        // ---------- Layout geral ----------
        setLayout(new BorderLayout(10, 10));
        add(painelFormulario, BorderLayout.NORTH);
        add(scrollPane, BorderLayout.CENTER);
        add(painelBotao, BorderLayout.SOUTH);

        // ---------- Configurações da janela ----------
        setSize(700, 300);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setLocationRelativeTo(null);
        setVisible(true);
    }

    // ---------- Método para adicionar cliente ----------
    private void adicionarCliente() {
        String nome = campoNome.getText().trim();
        String sobrenome = campoSobrenome.getText().trim();
        String telefone = campoTelefone.getText().trim();
        String endereco = campoEndereco.getText().trim();

        if (nome.isEmpty() || sobrenome.isEmpty() || telefone.isEmpty() || endereco.isEmpty()) {
            JOptionPane.showMessageDialog(this, "Preencha todos os campos!", "Aviso", JOptionPane.WARNING_MESSAGE);
            return;
        }

        modelo.addRow(new Object[]{nome, sobrenome, telefone, endereco});

        campoNome.setText("");
        campoSobrenome.setText("");
        campoTelefone.setText("");
        campoEndereco.setText("");
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> new TabelaComFormulario());
    }
}