/*******************************************************************************
 * This file is part of OpenNMS(R).
 *
 * Copyright (C) 2012 The OpenNMS Group, Inc.
 * OpenNMS(R) is Copyright (C) 1999-2012 The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is a registered trademark of The OpenNMS Group, Inc.
 *
 * OpenNMS(R) is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published
 * by the Free Software Foundation, either version 3 of the License,
 * or (at your option) any later version.
 *
 * OpenNMS(R) is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with OpenNMS(R).  If not, see:
 *      http://www.gnu.org/licenses/
 *
 * For more information contact:
 *     OpenNMS(R) Licensing <license@opennms.org>
 *     http://www.opennms.org/
 *     http://www.opennms.com/
 *******************************************************************************/

package org.opennms.netmgt.linkd;

import static org.junit.Assert.assertTrue;

import java.io.IOException;
import java.util.List;
import java.util.Properties;

import org.exolab.castor.xml.MarshalException;
import org.exolab.castor.xml.ValidationException;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.opennms.core.test.MockLogAppender;
import org.opennms.core.test.OpenNMSJUnit4ClassRunner;
import org.opennms.core.test.db.annotations.JUnitTemporaryDatabase;
import org.opennms.core.test.snmp.annotations.JUnitSnmpAgent;
import org.opennms.core.test.snmp.annotations.JUnitSnmpAgents;
import org.opennms.core.utils.BeanUtils;
import org.opennms.netmgt.capsd.Capsd;
import org.opennms.netmgt.dao.IpInterfaceDao;
import org.opennms.netmgt.model.OnmsIpInterface;
import org.opennms.netmgt.model.OnmsSnmpInterface;
import org.opennms.test.JUnitConfigurationEnvironment;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.transaction.annotation.Transactional;

/**
 * @author <a href="mailto:brozow@opennms.org">Mathew Brozowski</a>
 * @author <a href="mailto:antonio@opennme.it">Antonio Russo</a>
 * @author <a href="mailto:alejandro@opennms.org">Alejandro Galue</a>
 */

@RunWith(OpenNMSJUnit4ClassRunner.class)
@ContextConfiguration(locations={
        "classpath:/META-INF/opennms/mockEventIpcManager.xml",
        "classpath:/META-INF/opennms/applicationContext-dao.xml",
        "classpath:/META-INF/opennms/applicationContext-soa.xml",
        "classpath:/META-INF/opennms/applicationContext-daemon.xml",
        "classpath:/META-INF/opennms/applicationContext-commonConfigs.xml",
        "classpath:/META-INF/opennms/applicationContext-capsd.xml",
        // import simple defined events
        "classpath:/META-INF/opennms/smallEventConfDao.xml",
        // Override the capsd config with a stripped-down version
        "classpath:/META-INF/opennms/capsdTest.xml",
        // override snmp-config configuration
        "classpath:/META-INF/opennms/applicationContext-proxy-snmp.xml"
})
// TODO: this class should be the starting point for Integration tests
// either with linkd and capsd
@JUnitConfigurationEnvironment(systemProperties="org.opennms.provisiond.enableDiscovery=false")
@JUnitTemporaryDatabase
public class LinkdNms1055CapsdNetworkBuilderTest extends LinkdNms1055NetworkBuilder implements InitializingBean {

    
    @Autowired
    private IpInterfaceDao m_interfaceDao;

    @Autowired
    private Capsd m_capsd;
    
    @Override
    public void afterPropertiesSet() throws Exception {
        BeanUtils.assertAutowiring(this);
    }

    @Before
    public void setUp() throws Exception {
        Properties p = new Properties();
        p.setProperty("log4j.logger.org.hibernate.SQL", "WARN");

        MockLogAppender.setupLogging(p);
        assertTrue("Capsd must not be null", m_capsd != null);        
    }

    private final void printPenrose() {

        List<OnmsIpInterface> ips = m_interfaceDao.findByIpAddress(PENROSE_IP);
        assertTrue("Has only one ip interface", ips.size() == 1);

        OnmsIpInterface ip = ips.get(0);

        for (OnmsIpInterface ipinterface: ip.getNode().getIpInterfaces()) {
            if (ipinterface.getIfIndex() != null )
                printipInterface("PENROSE", ipinterface);
        }

        for (OnmsSnmpInterface snmpinterface: ip.getNode().getSnmpInterfaces()) {
            printSnmpInterface("PENROSE", snmpinterface);
        }
    }

    private final void printDelaware() {
        List<OnmsIpInterface> ips = m_interfaceDao.findByIpAddress(DELAWARE_IP);
        assertTrue("Has only one ip interface", ips.size() == 1);

        OnmsIpInterface ip = ips.get(0);

        for (OnmsIpInterface ipinterface: ip.getNode().getIpInterfaces()) {
            if (ipinterface.getIfIndex() != null )
                printipInterface("DELAWARE", ipinterface);
        }

        for (OnmsSnmpInterface snmpinterface: ip.getNode().getSnmpInterfaces()) {
            printSnmpInterface("DELAWARE", snmpinterface);
        }
    }

    private final void printPhoenix() {
        List<OnmsIpInterface> ips = m_interfaceDao.findByIpAddress(PHOENIX_IP);
        assertTrue("Has only one ip interface", ips.size() == 1);

        OnmsIpInterface ip = ips.get(0);

        for (OnmsIpInterface ipinterface: ip.getNode().getIpInterfaces()) {
            if (ipinterface.getIfIndex() != null )
                printipInterface("PHOENIX", ipinterface);
        }

        for (OnmsSnmpInterface snmpinterface: ip.getNode().getSnmpInterfaces()) {
            printSnmpInterface("PHOENIX", snmpinterface);
        }
    }

    private final void printAustin() {
        List<OnmsIpInterface> ips = m_interfaceDao.findByIpAddress(AUSTIN_IP);
        assertTrue("Has only one ip interface", ips.size() == 1);

        OnmsIpInterface ip = ips.get(0);

        for (OnmsIpInterface ipinterface: ip.getNode().getIpInterfaces()) {
            if (ipinterface.getIfIndex() != null )
                printipInterface("AUSTIN", ipinterface);
        }

        for (OnmsSnmpInterface snmpinterface: ip.getNode().getSnmpInterfaces()) {
            printSnmpInterface("AUSTIN", snmpinterface);        
        }
    }

    private final void printSanjose() {
        List<OnmsIpInterface> ips = m_interfaceDao.findByIpAddress(SANJOSE_IP);
        assertTrue("Has only one ip interface", ips.size() == 1);

        OnmsIpInterface ip = ips.get(0);

        for (OnmsIpInterface ipinterface: ip.getNode().getIpInterfaces()) {
            if (ipinterface.getIfIndex() != null )
                printipInterface("SANJOSE", ipinterface);
        }

        for (OnmsSnmpInterface snmpinterface: ip.getNode().getSnmpInterfaces()) {
            printSnmpInterface("SANJOSE", snmpinterface);
        }
    }
    
    private final void printRiovista() {
        List<OnmsIpInterface> ips = m_interfaceDao.findByIpAddress(RIOVISTA_IP);
        assertTrue("Has only one ip interface", ips.size() == 1);

        OnmsIpInterface ip = ips.get(0);

        for (OnmsIpInterface ipinterface: ip.getNode().getIpInterfaces()) {
            if (ipinterface.getIfIndex() != null )
                printipInterface("RIOVISTA", ipinterface);
        }

        for (OnmsSnmpInterface snmpinterface: ip.getNode().getSnmpInterfaces()) {
            printSnmpInterface("RIOVISTA", snmpinterface);
        }
    }

    @Test
    @JUnitSnmpAgents(value={
            @JUnitSnmpAgent(host=PENROSE_IP, port=161, resource="classpath:linkd/nms1055/"+PENROSE_NAME+"_"+PENROSE_IP+".txt"),
            @JUnitSnmpAgent(host=DELAWARE_IP, port=161, resource="classpath:linkd/nms1055/"+DELAWARE_NAME+"_"+DELAWARE_IP+".txt"),
            @JUnitSnmpAgent(host=PHOENIX_IP, port=161, resource="classpath:linkd/nms1055/"+PHOENIX_NAME+"_"+PHOENIX_IP+".txt"),
            @JUnitSnmpAgent(host=AUSTIN_IP, port=161, resource="classpath:linkd/nms1055/"+AUSTIN_NAME+"_"+AUSTIN_IP+".txt"),
            @JUnitSnmpAgent(host=SANJOSE_IP, port=161, resource="classpath:linkd/nms1055/"+SANJOSE_NAME+"_"+SANJOSE_IP+".txt"),
            @JUnitSnmpAgent(host=RIOVISTA_IP, port=161, resource="classpath:linkd/nms1055/"+RIOVISTA_NAME+"_"+RIOVISTA_IP+".txt")
    })
    @Transactional
    public final void testPenrose() throws MarshalException, ValidationException, IOException {
        m_capsd.init();
        m_capsd.start();

        m_capsd.scanSuspectInterface(PENROSE_IP);
        m_capsd.scanSuspectInterface(DELAWARE_IP);
        m_capsd.scanSuspectInterface(PHOENIX_IP);
        m_capsd.scanSuspectInterface(AUSTIN_IP);
        m_capsd.scanSuspectInterface(SANJOSE_IP);
        m_capsd.scanSuspectInterface(RIOVISTA_IP);

        printPenrose();
        printDelaware();
        printPhoenix();
        printAustin();
        printSanjose();
        printRiovista();

        m_capsd.stop();

        
    }       
}
