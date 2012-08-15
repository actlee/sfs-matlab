function kemar2mat(irsset,irspath)
%KEMAR2MAT converts IRs data given by our KEMAR to our mat-file based format
%
%   Usage: kemar2mat(irsset,irspath);
%
%   Input options:
%       irsset  - IR sets measured with VariSphear and KEMAR. Currently the
%                 following are available:
%                   'RAR_05m'               - HRIR of RAR with 0.5m distance
%                   'RAR_1m'                - HRIR of RAR with 1m distance
%                   'RAR_2m'                - HRIR of RAR with 2m distance
%                   'RAR_3m'                - HRIR of RAR with 3m distance
%                   'RAR_3m_small'          - HRIR of RAR with 3m distance and
%                                             small ears
%                   'RAR_3m_small2'         - HRIR of RAR with 3m distance and
%                                             small ears. Second reference
%                                             measurement
%                   'RAR_3m_head_rot'       - HRIR of RAR with 3m distance and
%                                             only head rotation of KEMAR
%                   'Auditorium3_session1'  - BRIR of Auditorium3 in TEL20,
%                                             session 1, 3 sources
%                   'Auditorium3_session2'  - BRIR of Auditorium3 in TEL20,
%                                             session 2, 3 sources
%                   'array_center_ls12'     - HRIR of loudspeaker array,
%                                             12 sources, center
%                   'array_center_ls13'     - HRIR of loudspeaker array,
%                                             13 sources, center
%                   'array_left_ls12'       - HRIR of loudspeaker array,
%                                             12 sources, left
%                   'array_left_ls13'       - HRIR of loudspeaker array,
%                                             13 sources, left
%                   'array_right_ls12'      - HRIR of loudspeaker array,
%                                             12 sources, right
%                   'array_right_ls13'      - HRIR of loudspeaker array,
%                                             13 sources, right
%                   'array_R1_phi30_ls6'    - HRIR of loudspeaker array,
%                                             6 sources, see AES129 paper
%                   'array_R1_phi30_ls13'   - HRIR of loudspeaker array,
%                                             13 sources, see AES129 paper
%                   'array_R1_phi60_ls6'    - HRIR of loudspeaker array,
%                                             6 sources, see AES129 paper
%                   'array_R1_phi60_ls13'   - HRIR of loudspeaker array,
%                                             13 sources, see AES129 paper
%                   'array_R4_phi30_ls13'   - HRIR of loudspeaker array,
%                                             13 sources, see AES129 paper
%                 NOTE: you still have to give the matching path to the given
%                 data set!
%       irspath - path to the directory containing the IR data
%
%   KEMAR2MAT(irsset,irspath) converts the IRs data given by the irsset
%   and stored at the given irspath in our own mat-file based format. See:
%   https://dev.qu.tu-berlin.de/projects/sfs/wiki/IRs_mat-file_format

% AUTHOR: Hagen Wierstorf,Lars-Erik Riechert


%% ===== Checking of input  parameters ==================================
nargmin = 2;
nargmax = 2;
error(nargchk(nargmin,nargmax,nargin));
isargchar(irsset);
isargdir(irspath);


%% ===== Computation =====================================================
% Dir to save the IRs
outdir = 'ir_databases';

% Initialize a new IR struct
irs = new_irs();

% Add common struct entries
irs.head = 'KEMAR 45BA';
irs.fs = 44100;
irs.head_elevation = NaN;
irs.torso_elevation = NaN;
irlength = 2048;    % this is suitable for an anechoic chamber, change this for
                    % real rooms in the corresponding if-section


%% ===== RAR ============================================================
% see: svn/capture/data/2010-11_RAR
if strncmpi(irsset,'RAR',3)
    % Common settings
    irs.room = 'Anechoic chamber ITA TU Berlin';
    irs.source = 'Genelec 8030A';
    irs.head_position = [0 0 0]';
    irs.head_reference = [0 1 0]';
    irs.source_reference = [0 0 0]';
    irlength = 2048;

    if strcmp(irsset,'RAR_05m')
        % irs struct entries
        irs.description = ...
            ['KEMAR measurement in RAR of the TU Berlin. Used elevation ', ...
             'angle: 0°; azimuth resolution: 1°. Rotation: torso.'];
        irs.ears = 'large';
        irs.source_position = [0 0.5 0]';
        irs.head_azimuth = NaN;
        irfilebase = 'KEMAR_1deg_0.5m_large_ears';

    elseif strcmp(irsset,'RAR_1m')
        irs.description = ...
            ['KEMAR measurement in RAR of the TU Berlin. Used elevation ', ...
             'angle: 0°; azimuth resolution: 1°. Rotation: torso.'];
        irs.ears = 'large';
        irs.source_position = [0 1 0]';
        irs.head_azimuth = NaN;
        irfilebase = 'KEMAR_1deg_1m_large_ear';

    elseif strcmp(irsset,'RAR_3m')
        irs.description = ...
            ['KEMAR measurement in RAR of the TU Berlin. Used elevation ', ...
             'angle: 0°; azimuth resolution: 1°. Rotation: torso.'];
        irs.ears = 'large';
        irs.source_position = [0 3 0]';
        irs.head_azimuth = NaN;
        irfilebase = 'KEMAR_1deg_3m_large_ears_';

    elseif strcmp(irsset,'RAR_3m_small')
        irs.description = ...
            ['KEMAR measurement in RAR of the TU Berlin. Used elevation ', ...
             'angle: 0°; azimuth resolution: 1°. Rotation: torso.'];
        irs.ears = 'small';
        irs.source_position = [0 3 0]';
        irs.head_azimuth = NaN;
        irfilebase = 'KEMAR_1deg_3m_';

    elseif strcmp(irsset,'RAR_3m_small2')
        irs.description = ...
            ['KEMAR measurement in RAR of the TU Berlin. Used elevation ', ...
             'angle: 0°; azimuth resolution: 1°. Rotation: torso. ', ...
             'Reference measurement.'];
        irs.ears = 'small';
        irs.source_position = [0 3 0]';
        irs.head_azimuth = NaN;
        irfilebase = 'KEMAR_1deg_3m_control_';

    elseif strcmp(irsset,'RAR_3m_head_rot')
        irs.description = ...
            ['KEMAR measurement in RAR of the TU Berlin. Used elevation ', ...
             'angle: 0°; azimuth resolution: 1°. Rotation: head.'];
        irs.ears = 'large';
        irs.source_position = [0 3 0]';
        irs.torso_azimuth = NaN;
        irfilebase = 'KEMAR_1deg_3m_large_ears_head_rotation_';
    end


%% ===== Auditorium 3 ===================================================
% see: svn/capture/data/2011-06-30_Auditorium3_KEMAR 
elseif strncmpi(irsset,'Auditorium3',11)
    % Common settings
    irs.description = ...
        ['KEMAR measurement in Auditorium3 in TEL-building of the TU Berlin. Used elevation ', ...
         'angle: 0°; azimuth resolution: 1°. Rotation: head. ,room height = 3 m',];
    irs.ears = 'large';
    irs.head_position = [0 0 0]';
    irs.head_reference = [0 1 0]';
    irs.torso_azimuth = NaN;
    irs.room = 'Auditorium3 in TEL-building (Telefunken-Hochhaus) Berlin';
    irs.room_corners = [
        -5   -4   -1.7;
         5   -4   -1.7;
         4.5  5.3 -1.7;
        -3.6  5.3 -1.7;
        -5   -4    1.3;
         5   -4    1.3;
         4.5  5.3  1.3;
        -3.6  5.3  1.3;
    ]';
    irlength = 44100;

    if strcmp(irsset,'Auditorium3_session1')
        sources = {
            1, [0    3.97 -0.05], [0 0 0], 'Genelec 8030A';
            2, [4.3  3.42 -0.05], [0 0 0], 'Genelec 8030A';
            3, [2.2 -1.94 -0.1 ], [0 0 0], 'Genelec 8030A';
        };
        irfilebase = '2011-06-30_15-24-43';
    elseif strcmp(irsset,'Auditorium3_session2')
        sources = {
            1, [ 0    1.5   -0.1], [0 0 0], 'Genelec 8030A';
            2, [-0.75 1.299 -0.1], [0 0 0], 'Genelec 8030A';
            3, [ 0.75 1.299 -0.1], [0 0 0], 'Genelec 8030A';
        };
        irfilebase = '2011-06-30_17-53-16';
    end


%% ===== loudspeaker array in RAR =======================================
% see: svn/capture/data/2011-09-30_RAR_loudspeaker_array
elseif strncmpi(irsset,'array',5)
    % Common settings
    irs.ears = 'large';
    irs.room = 'anechoic chamber TU Berlin';
    irs.room_corners = [
        -4.01 -4.81 -1.22;
        -4.01  8.74 -1.22;
         4.30  8.74 -1.22;
         4.30 -4.81 -1.22;
    ]';
    irs.head_azimuth = NaN;
    irlength = 2048;
    % Two loudspeaker arrays have been measured. One with a loudspeaker at x0 =
    % 0m, resulting in a total of 13 loudspeaker and one with the loudspeakers
    % at the position in between resulting in a total of 12 loudspeakers.
    sources12 = {
        1,  [ 0.825 0 0], [ 0.825 1 0], 'Fostex PM0.4';
        2,  [ 0.675 0 0], [ 0.675 1 0], 'Fostex PM0.4';
        3,  [ 0.525 0 0], [ 0.525 1 0], 'Fostex PM0.4';
        4,  [ 0.375 0 0], [ 0.375 1 0], 'Fostex PM0.4';
        5,  [ 0.225 0 0], [ 0.225 1 0], 'Fostex PM0.4';
        6,  [ 0.075 0 0], [ 0.075 1 0], 'Fostex PM0.4';
        7,  [-0.075 0 0], [-0.075 1 0], 'Fostex PM0.4';
        8,  [-0.225 0 0], [-0.225 1 0], 'Fostex PM0.4';
        9,  [-0.375 0 0], [-0.375 1 0], 'Fostex PM0.4';
        10, [-0.525 0 0], [-0.525 1 0], 'Fostex PM0.4';
        11, [-0.675 0 0], [-0.675 1 0], 'Fostex PM0.4';
        12, [-0.825 0 0], [-0.825 1 0], 'Fostex PM0.4';
    };
    sources13   = {
        1,  [ 0.90 0 0], [ 0.90 1 0], 'Fostex PM0.4';
        2,  [ 0.75 0 0], [ 0.75 1 0], 'Fostex PM0.4';
        3,  [ 0.60 0 0], [ 0.60 1 0], 'Fostex PM0.4';
        4,  [ 0.45 0 0], [ 0.45 1 0], 'Fostex PM0.4';
        5,  [ 0.30 0 0], [ 0.30 1 0], 'Fostex PM0.4';
        6,  [ 0.15 0 0], [ 0.15 1 0], 'Fostex PM0.4';
        7,  [ 0.00 0 0], [ 0.00 1 0], 'Fostex PM0.4';
        8,  [-0.15 0 0], [-0.15 1 0], 'Fostex PM0.4';
        9,  [-0.30 0 0], [-0.30 1 0], 'Fostex PM0.4';
        10, [-0.45 0 0], [-0.45 1 0], 'Fostex PM0.4';
        11, [-0.60 0 0], [-0.60 1 0], 'Fostex PM0.4';
        12, [-0.75 0 0], [-0.75 1 0], 'Fostex PM0.4';
        13, [-0.90 0 0], [-0.90 1 0], 'Fostex PM0.4';
    };

    if strcmp(irsset,'array_center_ls12')
        irs.head_reference = [0 0 0]';
        irs.head_position  = [0 2 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15 and loudspeakers positioned at the half position, which means we have 12 loudspeakers';
        irfilebase = '2011-10-01_10-06-45_src';
        sources = sources12;
    elseif strcmp(irsset,'array_center_ls13')
        irs.head_reference = [0 0 0]';
        irs.head_position  = [0 2 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15';
        sources = sources13;
        irfilebase =  '2011-09-30_15-29-16_src';
    elseif strcmp(irsset,'array_left_ls12')
        irs.head_reference = [-1.65 0 0]';
        irs.head_position  = [-1.65 2 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15 and loudspeakers positioned at the half position, which means we have 12 loudspeakers';
        sources = sources12;
        irfilebase =  '2011-10-02_11-44-24_src';
    elseif strcmp(irsset,'array_left_ls13')
        irs.head_reference = [-1.65 0 0]';
        irs.head_position  = [-1.65 2 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15';
        sources = sources13;
        irfilebase =  '2011-10-01_22-52-57_src';
    elseif strcmp(irsset,'array_right_ls12')
        irs.head_reference = [1.65 0 0]';
        irs.head_position  = [1.65 2 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15 and loudspeakers positioned at the half position, which means we have 12 loudspeakers';
        sources = sources12;
        irfilebase =  '2011-10-03_00-12-16_src';
    elseif strcmp(irsset,'array_right_ls13')
        irs.head_reference = [1.65 0 0]';
        irs.head_position  = [1.65 2 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15';
        sources = sources13;
        irfilebase =  '2011-10-03_12-12-17_src';
    elseif strcmp(irsset,'array_R1_phi30_ls6')
        irs.head_reference = [0 1 0]';
        irs.head_position  = [0.5 1.866 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15 and loudspeakers positioned at the half position, which means we have 12 loudspeakers';
        irfilebase =  '2011-10-04_10-23-59_src';
        sources = sources12(4:9,:);
    elseif strcmp(irsset,'array_R1_phi30_ls13')
        irs.head_reference = [0 1 0]';
        irs.head_position  = [0.5 1.866 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15';
        sources = sources13;
        irfilebase =  '2011-10-03_23-47-31_src';
    elseif strcmp(irsset,'array_R1_phi60_ls6')
        irs.head_reference = [0 1 0]';
        irs.head_position  = [0.866 1.5 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15 and loudspeakers positioned at the half position, which means we have 12 loudspeakers';
        sources = sources12(4:9,:);
        irfilebase =  '2011-10-04_12-40-23_src';
    elseif strcmp(irsset,'array_R1_phi60_ls13')
        irs.head_reference = [0 1 0]';
        irs.head_position  = [0.866 1.5 0]';
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15';
        irfilebase =  '2011-10-04_16-03-38_src';
        sources = sources13;
    elseif strcmp(irsset,'array_R4_phi30_ls13')
        irs.head_reference = [0 1 0]';
        irs.head_position  = [2 4.46 0]';
        sources = sources13;
        irs.description = 'HRIR of a 1.8m loudspeaker array with dx0=0.15';
        irfilebase =  '2011-10-04_21-51-48_src';
    else
        error('%s: The given irsset is unknown.',upper(mfilename));
    end

%% ===== loudspeaker array in Calypso =======================================
% see: svn/capture/data/2011-09-30_Calypso_loudspeaker_array
elseif strncmpi(irsset,'calypso',7)
    % Common settings
    irs.ears = 'large with AKGK601 on it';
    irs.room = 'Room Calypso, 15th floor Telefunken building, T-Labs, TU Berlin';
    irs.room_corners = [
         3.20 -2.12 -1.22;
        -2.45 -2.12 -1.22;
        -2.45  3.00 -1.22;
         3.20  3.00 -1.22;
    ]';
    irs.torso_azimuth = NaN;
    irs.head_reference = [0 1 0]';
    irs.head_position  = [0 0 0]';
    irlength = 4096;
    angle1 = -90;
    angle2 = 90;
    % Two loudspeaker arrays have been measured. One with a loudspeaker at x0 =
    % 0m, resulting in a total of 13 loudspeaker and one with the loudspeakers
    % at the position in between resulting in a total of 12 loudspeakers.
    sources = {
        1, [-1.33 1.5 0], [-1.33 0 0], 'Fostex PM0.4';
        2, [-1.18 1.5 0], [-1.18 0 0], 'Fostex PM0.4';
        3, [-1.04 1.5 0], [-1.04 0 0], 'Fostex PM0.4';
        4, [-0.89 1.5 0], [-0.89 0 0], 'Fostex PM0.4';
        5, [-0.75 1.5 0], [-0.75 0 0], 'Fostex PM0.4';
        6, [-0.60 1.5 0], [-0.60 0 0], 'Fostex PM0.4';
        7, [-0.45 1.5 0], [-0.45 0 0], 'Fostex PM0.4';
        8, [-0.30 1.5 0], [-0.30 0 0], 'Fostex PM0.4';
        9, [-0.15 1.5 0], [-0.15 0 0], 'Fostex PM0.4';
       10, [ 0.00 1.5 0], [ 0.00 0 0], 'Fostex PM0.4';
       11, [ 0.15 1.5 0], [ 0.15 0 0], 'Fostex PM0.4';
       12, [ 0.30 1.5 0], [ 0.30 0 0], 'Fostex PM0.4';
       13, [ 0.45 1.5 0], [ 0.45 0 0], 'Fostex PM0.4';
       14, [ 0.61 1.5 0], [ 0.61 0 0], 'Fostex PM0.4';
       15, [ 0.76 1.5 0], [ 0.76 0 0], 'Fostex PM0.4n';
       16, [ 0.91 1.5 0], [ 0.91 0 0], 'Fostex PM0.4n';
       17, [ 1.06 1.5 0], [ 1.06 0 0], 'Fostex PM0.4n';
       18, [ 1.21 1.5 0], [ 1.21 0 0], 'Fostex PM0.4n';
       19, [ 1.36 1.5 0], [ 1.36 0 0], 'Fostex PM0.4n';
    };

    if strcmp(irsset,'calypso_akg')
        irs.ears = 'large with AKGK601 on it';
        irs.description = ['BRIRs of a loudspeaker array with 15cm ', ...
            'distance between the speakers and 19 loudspeakers overall. ', ...
            'The headphone AKGK601 was mounted on the dummy head.'];
        irfilebase = '2012-03-31_21-43-28';
    elseif strcmp(irsset,'calypso')
        irs.ears = 'large';
        irs.description = ['BRIRs of a loudspeaker array with 15cm distance ',
            'between the speakers and 19 loudspeakers overall'];
        irfilebase = '';
    else
        error('%s: The given irsset is unknown.',upper(mfilename));
    end

else
    error('%s: the given irsset is not available.',upper(mfilename));
end


%% ===== Read the data ==================================================

% RAR
if strncmpi(irsset,'RAR',3)
    for jj = 1:360

        if strcmp(irsset,'RAR_3m_head_rot')
            irfile = sprintf('%s/%s%03.0f_%i.mat',irspath,irfilebase,jj,jj-181);
            irs.head_azimuth(jj) = correct_azimuth(-(180-jj+1)/180*pi);
        else
            irfile = sprintf('%s/%s%03.0f_%i.mat',irspath,irfilebase,jj,jj-1);
            irs.torso_azimuth(jj) = correct_azimuth(-(180-jj+1)/180*pi);
        end

        load(irfile);
        irs.apparent_azimuth(jj) = correct_azimuth((180-jj+1)/180*pi);
        irs.apparent_elevation(jj) = correct_azimuth(0);
        irs.left(:,jj) = vspolardata.ir_ch1(1:irlength);
        irs.right(:,jj) = vspolardata.ir_ch2(1:irlength);
    end
    % Save irs
    save_irs_without_position(irs,outdir,irsset);

% Auditorium3
elseif strncmpi(irsset,'Auditorium3',11)
    % Iterate over sources
    for ii = cell2mat(sources(:,1))' 

        irs.source_position = cell2mat(sources(ii,2))';
        irs.source_reference  = cell2mat(sources(ii,3))';
        
        for jj = -90:90
            irfile = sprintf('%s/%s_src%i_head%+1.3f.mat',irspath,irfilebase,ii,jj);
            load(irfile);
            irs.head_azimuth(jj+91) = correct_azimuth(rad(jj));
            direction = irs.head_position - irs.source_position;
            [phi, theta, r] = cart2sph(direction(1),direction(2),direction(3));
            phi = -phi - pi/2;
            irs.apparent_azimuth(jj+91) = correct_azimuth(-rad(jj)-phi);
            irs.apparent_elevation(jj+91) = correct_elevation(theta);
            irs.left(:,jj+91) = data.ir(1:irlength,1);
            irs.right(:,jj+91) = data.ir(1:irlength,2);
        end

        % Save irs
        name = sprintf('%s_src%i',irsset,ii);
        save_irs_with_position(irs,outdir,name);
    end

% Loudspeaker array in RAR
elseif strncmpi(irsset,'array',5)
    % Iterate over sources
    for ii = 1:length(cell2mat(sources(:,1)))
        irs.source_position = cell2mat(sources(ii,2))';
        irs.source_reference  = cell2mat(sources(ii,3))';

        if strncmpi(irsset,'array_R1_phi30',14) | strncmpi(irsset,'array_R4_phi30',14)
            angle1 = -75;
            angle2 =  75;
        elseif strncmpi(irsset,'array_R1_phi60',14)
            angle1 = -75;
            angle2 =  75;
        else
            angle1 = -180;
            angle2 =  179;
        end

        % calculating the offset in direction, coming from the head not to be
        % placed in front of the box
        headtosource_direction = irs.head_position - irs.source_position;
        [phi, theta, R] = ...
            cart2sph(headtosource_direction(1),headtosource_direction(2), ...
                headtosource_direction(3));
        offset = phi -pi/2;
        % calculating the offset in direction, coming from the head not facing
        % the box
        head_direction = irs.head_position - irs.head_reference;
        [phi, theta, R] = ...
            cart2sph(head_direction(1),head_direction(2),head_direction(3));
        offset = offset + pi/2  - phi;

        for jj = angle1:angle2
            irfile = sprintf('%s/%s%i_torso%+06.1f.mat',irspath,irfilebase,ii,jj);
            load(irfile);

            irs.head_azimuth(jj-angle1+1) = correct_azimuth(rad(jj));
            irs.apparent_azimuth(jj-angle1+1) = correct_azimuth(rad(-jj)+offset);
            irs.apparent_elevation(jj-angle1+1) = 0;

            irs.left(:,jj-angle1+1) = data.ir(1:irlength,1);
            irs.right(:,jj-angle1+1) = data.ir(1:irlength,2);
        end

        % Save irs
        name = sprintf('%s_src%02.0f',irsset,ii);
        save_irs_with_position(irs,outdir,name);
    end

    
% Loudspeaker array in Calypso
elseif strncmpi(irsset,'calypso',5)
    % Iterate over sources
    for ii = 1:length(cell2mat(sources(:,1)))
        irs.source = sources{ii,4};
        irs.source_position = cell2mat(sources(ii,2))';
        irs.source_reference  = cell2mat(sources(ii,3))';

        % calculating the offset in direction, coming from the head not to be
        % placed in front of the box
        headtosource_direction = irs.head_position - irs.source_position;
        [phi, theta, R] = ...
            cart2sph(headtosource_direction(1),headtosource_direction(2), ...
                headtosource_direction(3));
        phi = phi - pi/2;

        for jj = angle1:angle2
            irfile = sprintf('%s/%s_src%i_head%+06.1f.mat',irspath,irfilebase,ii,jj);
            load(irfile);

            irs.head_azimuth(jj-angle1+1) = correct_azimuth(data.head_azimuth);
            irs.apparent_azimuth(jj-angle1+1) = correct_azimuth(data.apparent_azimuth);
            irs.apparent_elevation(jj-angle1+1) = 0;

            irs.left(:,jj-angle1+1) = data.ir(1:irlength,1);
            irs.right(:,jj-angle1+1) = data.ir(1:irlength,2);
        end

        % Save irs
        name = sprintf('%s_src%02.0f',irsset,ii);
        save_irs_with_position(irs,outdir,name);
    end
end


%% Helper functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function save_irs_without_position(irs,outdir,irsset)

    % Calculate the distance between head and source
    irs.distance = norm(irs.head_position-irs.source_position);

    % Reorder fields
    irs = order_irs_fields(irs);
    % Reorder entries
    irs = correct_irs_angle_order(irs);
    % Check irs format
    check_irs(irs);

    % Create the outdir
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end

    % Write IR mat-file
    xs = irs.source_position - irs.head_position;
    outfile = sprintf('%s/QU_KEMAR_%s.mat',outdir,irsset);
    save_irs(irs,outfile);

end

function save_irs_with_position(irs,outdir,irsset)

    % Calculate the distance between head and source
    irs.distance = norm(irs.head_position-irs.source_position);

    % Reorder fields
    irs = order_irs_fields(irs);
    % Reorder entries
    irs = correct_irs_angle_order(irs);
    % Check irs format
    check_irs(irs);

    % Create the outdir
    if ~exist(outdir,'dir')
        mkdir(outdir);
    end

    % Write IR mat-file
    xs = irs.head_position - irs.source_position;
    outfile = sprintf('%s/QU_KEMAR_%s_xs%+.3f_ys%+.3f.mat', ...
        outdir,irsset,xs(1),xs(2));
    save_irs(irs,outfile);

end