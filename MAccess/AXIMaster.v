    `timescale 1ns / 1ps
    //////////////////////////////////////////////////////////////////////////////////
    // Company: 
    // Engineer: 
    // 
    // Create Date: 21.05.2016 15:13:43
    // Design Name: 
    // Module Name: AXIMaster
    // Project Name: 
    // Target Devices: 
    // Tool Versions: 
    // Description: 
    // 
    // Dependencies: 
    // 
    // Revision:
    // Revision 0.01 - File Created
    // Additional Comments:
    // 
    //////////////////////////////////////////////////////////////////////////////////
    
    `timescale 1 ns / 1 ps
    
    module AXIMaster #
    (
        // Users to add parameters here
    
        // User parameters ends
        // Do not modify the parameters beyond this line
    
        // Base address of targeted slave
        parameter  C_M_TARGET_SLAVE_BASE_ADDR    = 32'h40000000,
        // Burst Length. Supports 1, 2, 4, 8, 16, 32, 64, 128, 256 burst lengths
        // Thread ID Width
        parameter integer C_M_AXI_ID_WIDTH    = 1,
        // Width of Address Bus
        parameter integer C_M_AXI_ADDR_WIDTH    = 32,
        // Width of Data Bus
        parameter integer C_M_AXI_DATA_WIDTH    = 32,
        // Width of User Write Address Bus
        parameter integer C_M_AXI_AWUSER_WIDTH    = 0,
        // Width of User Read Address Bus
        parameter integer C_M_AXI_ARUSER_WIDTH    = 0,
        // Width of User Write Data Bus
        parameter integer C_M_AXI_WUSER_WIDTH    = 0,
        // Width of User Read Data Bus
        parameter integer C_M_AXI_RUSER_WIDTH    = 0,
        // Width of User Response Bus
        parameter integer C_M_AXI_BUSER_WIDTH    = 0
    )
    (
        // Users to add ports here
        input start_write_wire,
        input start_read_wire,
        input[C_M_AXI_ADDR_WIDTH-1:0] axi_awaddr_input,
        input[C_M_AXI_ADDR_WIDTH-1:0] axi_araddr_input,
        input R_isCache,
        input W_isCache,
        output WriteCompleted,
        output ReadCompleted,
        output reg [31:0] ReadData,
        input [255:0] WriteData,
        output reg ValidReadData,
        // Asserts when ERROR is detected
        output reg [1:0]  ReadError,
        output reg [1:0]  WriteError,
        // User ports ends
        // Do not modify the ports beyond this line
    
        // Global Clock Signal.
        input wire  M_AXI_ACLK,
        // Global Reset Singal. This Signal is Active Low
        input wire  M_AXI_ARESETN,
        // Master Interface Write Address ID
        output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_AWID,
        // Master Interface Write Address
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_AWADDR,
        // Burst length. The burst length gives the exact number of transfers in a burst
        output wire [7 : 0] M_AXI_AWLEN,
        // Burst size. This signal indicates the size of each transfer in the burst
        output wire [2 : 0] M_AXI_AWSIZE,
        // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
        output wire [1 : 0] M_AXI_AWBURST,
        // Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
        output wire  M_AXI_AWLOCK,
        // Memory type. This signal indicates how transactions
    // are required to progress through a system.
        output wire [3 : 0] M_AXI_AWCACHE,
        // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
        output wire [2 : 0] M_AXI_AWPROT,
        // Quality of Service, QoS identifier sent for each write transaction.
        output wire [3 : 0] M_AXI_AWQOS,
        // Optional User-defined signal in the write address channel.
        output wire [C_M_AXI_AWUSER_WIDTH-1 : 0] M_AXI_AWUSER,
        // Write address valid. This signal indicates that
    // the channel is signaling valid write address and control information.
        output wire  M_AXI_AWVALID,
        // Write address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
        input wire  M_AXI_AWREADY,
        // Master Interface Write Data.
        output wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_WDATA,
        // Write strobes. This signal indicates which byte
    // lanes hold valid data. There is one write strobe
    // bit for each eight bits of the write data bus.
        output wire [C_M_AXI_DATA_WIDTH/8-1 : 0] M_AXI_WSTRB,
        // Write last. This signal indicates the last transfer in a write burst.
        output wire  M_AXI_WLAST,
        // Optional User-defined signal in the write data channel.
        output wire [C_M_AXI_WUSER_WIDTH-1 : 0] M_AXI_WUSER,
        // Write valid. This signal indicates that valid write
    // data and strobes are available
        output wire  M_AXI_WVALID,
        // Write ready. This signal indicates that the slave
    // can accept the write data.
        input wire  M_AXI_WREADY,
        // Master Interface Write Response.
        input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_BID,
        // Write response. This signal indicates the status of the write transaction.
        input wire [1 : 0] M_AXI_BRESP,
        // Optional User-defined signal in the write response channel
        input wire [C_M_AXI_BUSER_WIDTH-1 : 0] M_AXI_BUSER,
        // Write response valid. This signal indicates that the
    // channel is signaling a valid write response.
        input wire  M_AXI_BVALID,
        // Response ready. This signal indicates that the master
    // can accept a write response.
        output wire  M_AXI_BREADY,
        // Master Interface Read Address.
        output wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_ARID,
        // Read address. This signal indicates the initial
    // address of a read burst transaction.
        output wire [C_M_AXI_ADDR_WIDTH-1 : 0] M_AXI_ARADDR,
        // Burst length. The burst length gives the exact number of transfers in a burst
        output wire [7 : 0] M_AXI_ARLEN,
        // Burst size. This signal indicates the size of each transfer in the burst
        output wire [2 : 0] M_AXI_ARSIZE,
        // Burst type. The burst type and the size information, 
    // determine how the address for each transfer within the burst is calculated.
        output wire [1 : 0] M_AXI_ARBURST,
        // Lock type. Provides additional information about the
    // atomic characteristics of the transfer.
        output wire  M_AXI_ARLOCK,
        // Memory type. This signal indicates how transactions
    // are required to progress through a system.
        output wire [3 : 0] M_AXI_ARCACHE,
        // Protection type. This signal indicates the privilege
    // and security level of the transaction, and whether
    // the transaction is a data access or an instruction access.
        output wire [2 : 0] M_AXI_ARPROT,
        // Quality of Service, QoS identifier sent for each read transaction
        output wire [3 : 0] M_AXI_ARQOS,
        // Optional User-defined signal in the read address channel.
        output wire [C_M_AXI_ARUSER_WIDTH-1 : 0] M_AXI_ARUSER,
        // Write address valid. This signal indicates that
    // the channel is signaling valid read address and control information
        output wire  M_AXI_ARVALID,
        // Read address ready. This signal indicates that
    // the slave is ready to accept an address and associated control signals
        input wire  M_AXI_ARREADY,
        // Read ID tag. This signal is the identification tag
    // for the read data group of signals generated by the slave.
        input wire [C_M_AXI_ID_WIDTH-1 : 0] M_AXI_RID,
        // Master Read Data
        input wire [C_M_AXI_DATA_WIDTH-1 : 0] M_AXI_RDATA,
        // Read response. This signal indicates the status of the read transfer
        input wire [1 : 0] M_AXI_RRESP,
        // Read last. This signal indicates the last transfer in a read burst
        input wire  M_AXI_RLAST,
        // Optional User-defined signal in the read address channel.
        input wire [C_M_AXI_RUSER_WIDTH-1 : 0] M_AXI_RUSER,
        // Read valid. This signal indicates that the channel
    // is signaling the required read data.
        input wire  M_AXI_RVALID,
        // Read ready. This signal indicates that the master can
    // accept the read data and response information.
        output wire  M_AXI_RREADY
    );
    
    
    // function called clogb2 that returns an integer which has the
    //value of the ceiling of the log base 2
    
      // function called clogb2 that returns an integer which has the 
      // value of the ceiling of the log base 2.                      
      function integer clogb2 (input integer bit_depth);              
      begin                                                           
        for(clogb2=0; bit_depth>0; clogb2=clogb2+1)                   
          bit_depth = bit_depth >> 1;                                 
        end                                                           
      endfunction                                                     
    
    // C_TRANSACTIONS_NUM is the width of the index counter for 
    // number of write or read transaction.
    localparam integer C_TRANSACTIONS_NUM = 4;
    
    // total number of burst transfers is master length divided by burst length and burst size
    localparam integer C_NO_BURSTS_REQ = 3;//C_MASTER_LENGTH-clogb2((C_M_AXI_BURST_LEN*C_M_AXI_DATA_WIDTH/8)-1);
    // Example State machine to initialize counter, initialize write transactions, 
    // initialize read transactions and comparison of read data with the 
    // written data words.
    parameter [1:0] IDLE = 2'b00, // This state initiates AXI4Lite transaction 
            // after the state machine changes state to INIT_WRITE 
            // when there is 0 to 1 transition on INIT_AXI_TXN
        INIT_WRITE   = 2'b01, // This state initializes write transaction,
            // once writes are done, the state machine 
            // changes state to INIT_READ 
        INIT_READ = 2'b10, // This state initializes read transaction
            // once reads are done, the state machine 
            // changes state to INIT_COMPARE 
        INIT_COMPARE = 2'b11; // This state issues the status of comparison 
            // of the written data with the read data    
    
     reg [1:0] mst_exec_rstate;
     reg [1:0] mst_exec_wstate;
    // AXI4LITE signals
    //AXI4 internal temp signals
    reg [C_M_AXI_ADDR_WIDTH-1 : 0]     axi_awaddr;
    reg      axi_awvalid;
    reg [C_M_AXI_DATA_WIDTH-1 : 0]     axi_wdata;
    reg      axi_wlast;
    reg      axi_wvalid;
    reg      axi_bready;
    reg [C_M_AXI_ADDR_WIDTH-1 : 0]     axi_araddr;
    reg      axi_arvalid;
    reg      axi_rready;
    //write beat count in a burst
    reg [C_TRANSACTIONS_NUM : 0]     write_index;
    //read beat count in a burst
    reg [C_TRANSACTIONS_NUM : 0]     read_index;
    //size of C_M_AXI_BURST_LEN length burst in bytes
    wire [C_TRANSACTIONS_NUM+2 : 0]     R_burst_size_bytes;
    wire [C_TRANSACTIONS_NUM+2 : 0]     W_burst_size_bytes;
    //The burst counters are used to track the number of burst transfers of C_M_AXI_BURST_LEN burst length needed to transfer 2^C_MASTER_LENGTH bytes of data.
    reg [C_NO_BURSTS_REQ : 0]     write_burst_counter;
    reg [C_NO_BURSTS_REQ : 0]     read_burst_counter;
    reg      start_single_burst_write;
    reg      start_single_burst_read;
    reg      writes_done;
    reg      reads_done;
    reg      compare_done;
    reg      burst_write_active;
    reg      burst_read_active;
    reg [C_M_AXI_DATA_WIDTH-1 : 0]     expected_rdata;
    //Interface response error flags
    wire      write_resp_error;
    wire      read_resp_error;
    wire      wnext;
    wire      rnext;
    reg      init_txn_ff;
    reg      init_txn_ff2;
    reg      init_txn_edge;
    wire      init_txn_pulse;
    reg write_completed;
    reg read_completed;
    reg[7:0] R_burst_len;
    reg[7:0] W_burst_len;
    reg[1:0] temp_read_error;
    
    // I/O Connections assignments
    
    //I/O Connections. Write Address (AW)
    assign M_AXI_AWID    = 'b0;
    //The AXI address is a concatenation of the target base address + active offset range
    assign M_AXI_AWADDR    = /*C_M_TARGET_SLAVE_BASE_ADDR + */ axi_awaddr;
    //Burst LENgth is number of transaction beats, minus 1
    assign M_AXI_AWLEN    = W_burst_len - 1;
    //Size should be C_M_AXI_DATA_WIDTH, in 2^SIZE bytes, otherwise narrow bursts are used
    assign M_AXI_AWSIZE    = clogb2((C_M_AXI_DATA_WIDTH/8)-1);
    //INCR burst type is usually used, except for keyhole bursts
    assign M_AXI_AWBURST    = 2'b10;
    assign M_AXI_AWLOCK    = 1'b0;
    //Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
    assign M_AXI_AWCACHE    = 4'b0010;
    assign M_AXI_AWPROT    = 3'h0;
    assign M_AXI_AWQOS    = 4'h0;
    assign M_AXI_AWUSER    = 'b1;
    assign M_AXI_AWVALID    = axi_awvalid;
    //Write Data(W)
    assign M_AXI_WDATA    = axi_wdata;
    //All bursts are complete and aligned in this example
    assign M_AXI_WSTRB    = {(C_M_AXI_DATA_WIDTH/8){1'b1}};
    assign M_AXI_WLAST    = axi_wlast;
    assign M_AXI_WUSER    = 'b0;
    assign M_AXI_WVALID    = axi_wvalid;
    //Write Response (B)
    assign M_AXI_BREADY    = axi_bready;
    //Read Address (AR)
    assign M_AXI_ARID    = 'b0;
    assign M_AXI_ARADDR    = /*C_M_TARGET_SLAVE_BASE_ADDR +*/ axi_araddr;
    //Burst LENgth is number of transaction beats, minus 1
    assign M_AXI_ARLEN    = R_burst_len - 1;
    //Size should be C_M_AXI_DATA_WIDTH, in 2^n bytes, otherwise narrow bursts are used
    assign M_AXI_ARSIZE    = clogb2((C_M_AXI_DATA_WIDTH/8)-1);
    //INCR burst type is usually used, except for keyhole bursts
    assign M_AXI_ARBURST    = 2'b10;
    assign M_AXI_ARLOCK    = 1'b0;
    //Update value to 4'b0011 if coherent accesses to be used via the Zynq ACP port. Not Allocated, Modifiable, not Bufferable. Not Bufferable since this example is meant to test memory, not intermediate cache. 
    assign M_AXI_ARCACHE    = 4'b0010;
    assign M_AXI_ARPROT    = 3'h0;
    assign M_AXI_ARQOS    = 4'h0;
    assign M_AXI_ARUSER    = 'b1;
    assign M_AXI_ARVALID    = axi_arvalid;
    //Read and Read Response (R)
    assign M_AXI_RREADY    = axi_rready;
    //Burst size in bytes
    assign R_burst_size_bytes    = R_burst_len * C_M_AXI_DATA_WIDTH/8;
    assign W_burst_size_bytes    = W_burst_len * C_M_AXI_DATA_WIDTH/8;
    assign WriteCompleted =  write_completed ;
    assign ReadCompleted  =  read_completed  ;
    
    //--------------------
    //Write Address Channel
    //--------------------
    
    // The purpose of the write address channel is to request the address and 
    // command information for the entire transaction.  It is a single beat
    // of information.
    
    // The AXI4 Write address channel in this example will continue to initiate
    // write commands as fast as it is allowed by the slave/interconnect.
    // The address will be incremented on each accepted address transaction,
    // by burst_size_byte to point to the next address. 
    
      always @(posedge M_AXI_ACLK)                                   
      begin                                                                
                                                                           
        if (M_AXI_ARESETN == 0)                                           
          begin                                                            
            axi_awvalid <= 1'b0;                                           
          end                                                              
        // If previously not valid , start next transaction                
        else if (~axi_awvalid && mst_exec_wstate == IDLE && start_write_wire)                 
          begin                                                            
            axi_awvalid <= 1'b1;                                           
          end                                                              
        /* Once asserted, VALIDs cannot be deasserted, so axi_awvalid      
        must wait until transaction is accepted */                         
        else if (M_AXI_AWREADY && axi_awvalid)                             
          begin                                                            
            axi_awvalid <= 1'b0;                               
          end                                                              
        else                                                               
          axi_awvalid <= axi_awvalid;                                      
        end                                                                
                                                                           
                                                                           
    // Next address after AWREADY indicates previous address acceptance    
      always @(posedge M_AXI_ACLK)                                         
      begin                                                                
        if (M_AXI_ARESETN == 0)                                            
          begin                                                            
            axi_awaddr <= 'b0;                                             
          end                                                              
        else if (M_AXI_AWREADY && axi_awvalid)                             
          begin                                                            
            axi_awaddr <= axi_awaddr + W_burst_size_bytes;            
          end                                                              
       else if (mst_exec_wstate == IDLE && start_write_wire)
           begin
               axi_awaddr <= axi_awaddr_input;
           end
       else
          begin                                                             
            axi_awaddr <= axi_awaddr;                                     
          end                   
      end                                             
    
    
    //--------------------
    //Write Data Channel
    //--------------------
    
    //The write data will continually try to push write data across the interface.
    
    //The amount of data accepted will depend on the AXI slave and the AXI
    //Interconnect settings, such as if there are FIFOs enabled in interconnect.
    
    //Note that there is no explicit timing relationship to the write address channel.
    //The write channel has its own throttling flag, separate from the AW channel.
    
    //Synchronization between the channels must be determined by the user.
    
    //The simpliest but lowest performance would be to only issue one address write
    //and write data burst at a time.
    
    //In this example they are kept in sync by using the same address increment
    //and burst sizes. Then the AW and W channels have their transactions measured
    //with threshold counters as part of the user logic, to make sure neither 
    //channel gets too far ahead of each other.
    
    //Forward movement occurs when the write channel is valid and ready
    
    assign wnext = M_AXI_WREADY & axi_wvalid;                                   
                                                                                        
    // WVALID logic, similar to the axi_awvalid always block above                      
    always @(posedge M_AXI_ACLK)                                                      
      begin                                                                             
        if (M_AXI_ARESETN == 0)                                                        
          begin                                                                         
            axi_wvalid <= 1'b0;                                                         
          end                                                                           
        // If previously not valid, start next transaction                              
        else if (~axi_wvalid && M_AXI_AWREADY && axi_awvalid)                               
          begin                                                                         
            axi_wvalid <= 1'b1;                                                         
          end                                                                           
        /* If WREADY and too many writes, throttle WVALID                               
        Once asserted, VALIDs cannot be deasserted, so WVALID                           
        must wait until burst is complete with WLAST */                                 
        else if (wnext && axi_wlast)                                                    
          axi_wvalid <= 1'b0;                                                           
        else                                                                            
          axi_wvalid <= axi_wvalid;                                                     
      end                                                                               
                                                                                        
                                                                                        
    //WLAST generation on the MSB of a counter underflow                                
    //WVALID logic, similar to the axi_awvalid always block above                      
      always @(posedge M_AXI_ACLK)                                                      
      begin                                                                             
        if (M_AXI_ARESETN == 0)                                                        
          begin                                                                         
            axi_wlast <= 1'b0;                                                          
          end                                                                           
        // axi_wlast is asserted when the write index                                   
        // count reaches the penultimate count to synchronize                           
        // with the last write data when write_index is b1111                           
        // else if (&(write_index[C_TRANSACTIONS_NUM-1:1])&& ~write_index[0] && wnext)  
        else if ((write_index == W_burst_len-2 && wnext) || (W_burst_len == 1 && M_AXI_AWREADY && axi_awvalid))
          begin                                                                         
            axi_wlast <= 1'b1;                                                          
          end                                                                           
        // Deassrt axi_wlast when the last write data has been                          
        // accepted by the slave with a valid response                                  
        else if (wnext)                                                                 
          axi_wlast <= 1'b0;                                                            
        else if (axi_wlast && W_burst_len == 1 && axi_wvalid && M_AXI_WREADY)                                   
          axi_wlast <= 1'b0;                                                            
        else                                                                            
          axi_wlast <= axi_wlast;                                                       
      end                                                                               
                                                                                        
                                                                                        
    /* Burst length counter. Uses extra counter register bit to indicate terminal       
     count to reduce decode logic */                                                    
      always @(posedge M_AXI_ACLK)                                                      
      begin                                                                             
        if (M_AXI_ARESETN == 0 || mst_exec_wstate == IDLE)    
          begin                                                                         
            write_index <= 0;                                                           
          end                                                                           
        else if (wnext && (write_index != W_burst_len-1))                         
          begin                                                                         
            write_index <= write_index + 1;                                             
          end                                                                           
        else                                                                            
          write_index <= write_index;                                                   
      end                                                                               
                                                                                        
    /* Write Data Generator                                                             
     Data pattern is only a simple incrementing count from 0 for each burst  */         
      always @(posedge M_AXI_ACLK)                                                      
      begin                                                                             
        if (M_AXI_ARESETN == 0)                                                         
          axi_wdata <= 32'h00000000;                                                             
        //else if (wnext && axi_wlast)                                                  
        //  axi_wdata <= 'b0;                                                           
        else if (wnext)                                                                 
          axi_wdata <= write_index == 0 ? WriteData[63:32]   : 
                       write_index == 1 ? WriteData[95:64]   :
                       write_index == 2 ? WriteData[127:96]  : 
                       write_index == 3 ? WriteData[159:128] :
                       write_index == 4 ? WriteData[191:160] :
                       write_index == 5 ? WriteData[223:192] :
                       write_index == 6 ? WriteData[255:224] : 0;                   
        else if(M_AXI_AWREADY && axi_awvalid) begin
          axi_wdata <= WriteData[31:0];
        end                                                 
        else                                                                            
          axi_wdata <= axi_wdata;                                                       
        end                                                                             
    
    
    //----------------------------
    //Write Response (B) Channel
    //----------------------------
    
    //The write response channel provides feedback that the write has committed
    //to memory. BREADY will occur when all of the data and the write address
    //has arrived and been accepted by the slave.
    
    //The write issuance (number of outstanding write addresses) is started by 
    //the Address Write transfer, and is completed by a BREADY/BRESP.
    
    //While negating BREADY will eventually throttle the AWREADY signal, 
    //it is best not to throttle the whole data channel this way.
    
    //The BRESP bit [1] is used indicate any errors from the interconnect or
    //slave for the entire write burst. This example will capture the error 
    //into the ERROR output. 
    
      always @(posedge M_AXI_ACLK)                                     
      begin                                                                 
        if (M_AXI_ARESETN == 0)                                            
          begin                                                             
            axi_bready <= 1'b0;                                             
          end                                                               
        // accept/acknowledge bresp with axi_bready by the master           
        // when last transfer occurs                       
        else if ((axi_wlast && axi_wvalid && M_AXI_WREADY) && ~axi_bready)                               
          begin                                                             
            axi_bready <= 1'b1;                                             
          end                                                               
        // deassert after one clock cycle                                   
        else if (axi_bready && M_AXI_BVALID)                                                
          begin                                                             
            axi_bready <= 1'b0;                                             
          end                                                               
        // retain the previous value                                        
        else                                                                
          axi_bready <= axi_bready;                                         
      end                                                                   
                                                                            
                                                                            
    //Flag any write response errors                                        
    assign write_resp_error = axi_bready & M_AXI_BVALID & M_AXI_BRESP[1];
    
    //----------------------------
    //Read Address Channel
    //----------------------------
    
    //The Read Address Channel (AW) provides a similar function to the
    //Write Address channel- to provide the tranfer qualifiers for the burst.
    
    //In this example, the read address increments in the same
    //manner as the write address channel.
    
      always @(posedge M_AXI_ACLK)                                 
      begin                                                                   
        if (M_AXI_ARESETN == 0 )                                         
          begin                                                          
            axi_arvalid <= 1'b0;                                         
          end                                                            
        // If previously not valid , start next transaction              
        else if (~axi_arvalid && mst_exec_rstate == IDLE && start_read_wire)                
          begin                                                          
            axi_arvalid <= 1'b1;                                         
          end                                                            
        else if (M_AXI_ARREADY && axi_arvalid)                           
          begin                                                          
            axi_arvalid <= 1'b0;                                         
          end                                                            
        else                                                             
          axi_arvalid <= axi_arvalid;                                    
      end                                                                                                                         
                                                                         
    // Next address after ARREADY indicates previous address acceptance  
      always @(posedge M_AXI_ACLK)                                       
      begin                                                              
        if (M_AXI_ARESETN == 0)                                          
          begin                                                          
            axi_araddr <= 'b0;                                           
          end                                                            
        else if (M_AXI_ARREADY && axi_arvalid)                           
          begin                                                          
            axi_araddr <= axi_araddr + R_burst_size_bytes;                 
          end       
        else if (mst_exec_rstate == IDLE && start_read_wire)
          begin
            axi_araddr <= axi_araddr_input;
          end                                                     
        else                                                             
          axi_araddr <= axi_araddr;                                      
      end                                           
    
    
    //--------------------------------
    //Read Data (and Response) Channel
    //--------------------------------
    
     // Forward movement occurs when the channel is valid and ready   
     assign rnext = M_AXI_RVALID && axi_rready;                            
                                                                            
                                                                            
    // Burst length counter. Uses extra counter register bit to indicate    
    // terminal count to reduce decode logic                                
      always @(posedge M_AXI_ACLK)                                          
      begin                                                                 
        if (M_AXI_ARESETN == 0 || mst_exec_rstate == IDLE )                  
          begin                                                             
            read_index <= 0;                                                
          end                                                               
        else if (rnext && (read_index != R_burst_len-1))              
          begin                                                             
            read_index <= read_index + 1;                                   
          end                                                               
        else                                                                
            read_index <= read_index;                                         
      end                                                                   
                                                                            
                                                                            
    /*                                                                      
     The Read Data channel returns the results of the read request          
                                                                            
     In this example the data checker is always able to accept              
     more data, so no need to throttle the RREADY signal                    
     */                                                                     
      always @(posedge M_AXI_ACLK)                                          
      begin                                                                 
        if (M_AXI_ARESETN == 0 )                  
          begin                                                             
            axi_rready <= 1'b0;                                             
          end                                                               
        // accept/acknowledge rdata/rresp with axi_rready by the master     
        // when M_AXI_RVALID is asserted by slave                           
        else if (M_AXI_RVALID && M_AXI_RLAST && axi_rready)                       
          begin                                                                
           axi_rready <= 1'b0;                                  
          end   
        else if (~axi_rready && M_AXI_ARREADY && axi_arvalid)
           begin
               axi_rready <= 1'b1;
           end                                     
        // retain the previous value                 
      end                                                                                                            
    
      always @(posedge M_AXI_ACLK)                                          
          begin                                                        
            //Only check data when RVALID and RREADY are active                             
            if(M_AXI_ARESETN == 0) begin
                ReadData <= 0;
                ValidReadData <= 0;
            end
            else if (rnext) begin  
              ReadData <= M_AXI_RDATA;
              ValidReadData <= 1;    
            end
            else begin
              ValidReadData <= 0;
            end                                                                                            
          end    
       
      always @(posedge M_AXI_ACLK) begin   
        
      end                             
                                                                           
    //Flag any read response errors                                         
    assign read_resp_error = axi_rready & M_AXI_RVALID & M_AXI_RRESP[1];
    
    always @(posedge M_AXI_ACLK) begin
        if (M_AXI_ARESETN == 0)                                          
          begin                                                          
            ReadError <= 2'b0; 
                                                      
          end                                                            
        else if(read_resp_error) 
          begin
            ReadError <= M_AXI_RRESP;
          end
        
        
    end                             
    //----------------------------------
    //Example design error register
    //----------------------------------
    
    //Register and hold any data mismatches, or read/write interface errors 
    
      always @(posedge M_AXI_ACLK)                                 
      begin                                                              
        if (M_AXI_ARESETN == 0)                                          
          begin                                                          
            WriteError <= 2'b0;                                           
          end                                                            
        else if (write_resp_error)   
          begin                                                           
            WriteError <= M_AXI_BRESP;                                       
          end                                                              
        else begin                                                      
          WriteError <= 2'b0;
        end                                     
      end                                                                                                                                         
                                                                                                                
      //implement master command interface state machine                                                        
                                                                                                                
      always @ ( posedge M_AXI_ACLK)                                                                            
      begin
        if (M_AXI_ARESETN == 1'b0 )                                                                             
          begin                                                                                                 
            // reset condition                                                                                  
            // All the signals are assigned default values under reset condition                                
            mst_exec_rstate      <= IDLE;     
            mst_exec_wstate      <= IDLE;                                                                                                                                
            start_single_burst_read  <= 1'b0;                                                                   
            compare_done      <= 1'b0;    
            temp_read_error <= 0;                                                                      
            
            write_completed <= 0;
            read_completed <= 0;
          end                                                                                                   
        else                                                                                                    
          begin
            
            if(axi_bready & M_AXI_BVALID)
               write_completed <= 1;
            
            if (M_AXI_RVALID && axi_rready && M_AXI_RLAST) 
               read_completed <= 1; 
                                                                                                                                                                                                                                                                                                
            case (mst_exec_rstate)                                                                                                                                                                                  
              IDLE:                                                                                     
                // This state is responsible to wait for user defined C_M_START_COUNT                           
                // number of clock cycles.  
                begin                       
                     if(start_read_wire != 1'b0) begin
                           mst_exec_rstate  <= INIT_READ;
                           if(R_isCache) begin
                              R_burst_len <= 8;
                           end
                           else begin
                              R_burst_len <= 1;
                           end
                     end                                                                         
                end                                                                                                                                                                                         
                                                                                       
              INIT_READ:                                                                                        
                // This state is responsible to issue start_single_read pulse to                                
                // initiate a read transaction. Read transactions will be                                       
                // issued until burst_read_active signal is asserted.                                           
                // read controller             
                if(read_completed) begin
                   ReadError <= 2'b0;
                   mst_exec_rstate <= IDLE;
                   read_completed <= 0;
                   temp_read_error <= 0;
                end 
                                                                                                                                                                                
            endcase 
            
            case(mst_exec_wstate) 
               IDLE:
                  begin
                   if(start_write_wire != 1'b0) begin
                         mst_exec_wstate  <= INIT_WRITE; // Go write 
                         if(W_isCache) begin
                              W_burst_len <= 8;
                         end
                         else begin
                              W_burst_len <= 1;
                         end
                    end
                  end                
               INIT_WRITE:                                                                                       
                // This state is responsible to issue start_single_write pulse to                               
                // initiate a write transaction. Write transactions will be                                     
                // issued until burst_write_active signal is asserted.                                          
                // write controller  
                    if(write_completed) begin
                       WriteError <= 2'b0;
                       mst_exec_wstate  <= IDLE;
                       write_completed <= 0;
                    end                
            endcase                                                                                  
         end
      end //MASTER_EXECUTION_PROC                                                                               
                                                                                                                
                                                                                                                
      // burst_write_active signal is asserted when there is a burst write transaction                          
      // is initiated by the assertion of start_single_burst_write. burst_write_active                          
      // signal remains asserted until the burst write is accepted by the slave                                 
      always @(posedge M_AXI_ACLK)                                                                              
      begin                                                                                                     
        if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
          burst_write_active <= 1'b0;                                                                                                                                                        
        //The burst_write_active is asserted when a write burst transaction is initiated                        
        else if (start_single_burst_write)                                                                      
          burst_write_active <= 1'b1;                                                                           
        else if (M_AXI_BVALID && axi_bready)                                                                    
          burst_write_active <= 0;                                                                              
      end                                                                                                       
                                                                                                                
     // Check for last write completion.                                                                        
                                                                                                                
     // This logic is to qualify the last write count with the final write                                      
     // response. This demonstrates how to confirm that a write has been                                        
     // committed.                                                                                              
                                                                                                                
      always @(posedge M_AXI_ACLK)                                                                              
      begin                                                                                                     
        if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
          writes_done <= 1'b0;                                                                                  
                                                                                                                
        //The writes_done should be associated with a bready response                                           
        //else if (M_AXI_BVALID && axi_bready && (write_burst_counter == {(C_NO_BURSTS_REQ-1){1}}) && axi_wlast)
        else if (M_AXI_BVALID && (write_burst_counter[C_NO_BURSTS_REQ]) && axi_bready)                          
          writes_done <= 1'b1;                                                                                  
        else                                                                                                    
          writes_done <= writes_done;                                                                           
        end                                                                                                     
                                                                                                                
      // burst_read_active signal is asserted when there is a burst write transaction                           
      // is initiated by the assertion of start_single_burst_write. start_single_burst_read                     
      // signal remains asserted until the burst read is accepted by the master                                 
      always @(posedge M_AXI_ACLK)                                                                              
      begin                                                                                                     
        if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
          burst_read_active <= 1'b0;                                                                            
                                                                                                                
        //The burst_write_active is asserted when a write burst transaction is initiated                        
        else if (start_single_burst_read)                                                                       
          burst_read_active <= 1'b1;                                                                            
        else if (M_AXI_RVALID && axi_rready && M_AXI_RLAST)                                                     
          burst_read_active <= 0;                                                                               
        end                                                                                                     
                                                                                                                
                                                                                                                
     // Check for last read completion.                                                                         
                                                                                                                
     // This logic is to qualify the last read count with the final read                                        
     // response. This demonstrates how to confirm that a read has been                                         
     // committed.                                                                                              
                                                                                                                
      always @(posedge M_AXI_ACLK)                                                                              
      begin                                                                                                     
        if (M_AXI_ARESETN == 0 || init_txn_pulse == 1'b1)                                                                                 
          reads_done <= 1'b0;                                                                                   
                                                                                                                
        //The reads_done should be associated with a rready response                                            
        //else if (M_AXI_BVALID && axi_bready && (write_burst_counter == {(C_NO_BURSTS_REQ-1){1}}) && axi_wlast)
        else if (M_AXI_RVALID && axi_rready && (read_index == R_burst_len-1) && (read_burst_counter[C_NO_BURSTS_REQ]))
          reads_done <= 1'b1;                                                                                   
        else                                                                                                    
          reads_done <= reads_done;                                                                             
        end                                                                                                     
    
    // Add user logic here
    // User logic ends
    
    endmodule
